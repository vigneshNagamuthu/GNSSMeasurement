import csv
import time
from datetime import datetime
from find_lat_long import find_gps_loc
from sat_connected import get_satellite_snr

PORT = "/dev/ttyACM0"

# Map fix quality codes to readable text
FIX_QUALITY_MAP = {
    "0": "Invalid",
    "1": "GPS fix",
    "2": "DGPS fix",
    "4": "RTK fixed",
    "5": "RTK float",
    "6": "Estimated"
}

# CSV filename with timestamp
csv_filename = f"gnss_log_{datetime.now().strftime('%Y%m%d_%H%M%S Outdoor(Canteen)')}.csv"

# Open CSV file once in append mode
with open(csv_filename, mode="w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    # Header row
    writer.writerow([
        "Timestamp", "Latitude", "Longitude",
        "Fix Quality", "Fix Quality Text",
        "Num Satellites", "PRN", "SNR", "Elevation", "Azimuth"
    ])

    print(f"Logging GNSS data every second. Press Ctrl+C to stop.\n")

    try:
        while True:
            # Get fixed location
            gps_data = next(find_gps_loc(PORT))
            fix_quality_text = FIX_QUALITY_MAP.get(gps_data['fix_quality'], "Unknown")
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            print(
                f"[{timestamp}] Location: Lat={gps_data['latitude']}, Lon={gps_data['longitude']}, "
                f"Fix Quality = {gps_data['fix_quality']} ({fix_quality_text}), "
                f"Satellites = {gps_data['num_satellites']}"
            )

            # Get satellite + SNR info
            for prn, snr, elev, azim in get_satellite_snr(PORT):
                print(f"  PRN {prn}: SNR = {snr}, Elev = {elev}, Azim = {azim}")
                writer.writerow([
                    timestamp,
                    gps_data['latitude'],
                    gps_data['longitude'],
                    gps_data['fix_quality'],
                    gps_data['num_satellites'],
                    prn, snr, elev, azim
                ])

            csvfile.flush()  # Ensure data is written to disk
            time.sleep(1)    # Wait 1 second before next query

    except KeyboardInterrupt:
        print(f"\nData saved to {csv_filename}")
