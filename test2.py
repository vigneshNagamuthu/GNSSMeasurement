import serial
import time
import csv
from datetime import datetime

# ------------------- PRN to Constellation Mapping -------------------
def prn_to_constellation(prn):
    prn = int(prn)
    if 1 <= prn <= 32:
        return "GPS"
    elif 33 <= prn <= 64:
        return "SBAS"
    elif 65 <= prn <= 96:
        return "GLONASS"
    elif 120 <= prn <= 158:
        return "SBAS"
    elif 159 <= prn <= 163:
        return "QZSS"
    elif 193 <= prn <= 197:
        return "QZSS"
    elif 201 <= prn <= 237:
        return "BeiDou"
    elif 301 <= prn <= 336:
        return "Galileo"
    elif 401 <= prn <= 414:
        return "NavIC"
    else:
        return "Unknown"

# ------------------- Parsing Functions -------------------
def parse_gsa(line):
    parts = line.split(',')
    return set(p for p in parts[3:15] if p)

def parse_gsv(line):
    parts = line.split(',')
    sat_info = {}
    # Iterate every group of 4 fields (PRN, Elev, Azimuth, SNR)
    for i in range(4, len(parts) - 4, 4):
        try:
            prn = parts[i]
            elev = parts[i + 1]
            azim = parts[i + 2]
            snr = parts[i + 3]
            if prn:
                sat_info[prn] = {
                    "elevation": elev if elev else "N/A",
                    "azimuth": azim if azim else "N/A",
                    "snr": snr if snr else "N/A"
                }
        except IndexError:
            continue
    return sat_info

# ------------------- Main GNSS Reading Function -------------------
def get_satellite_snr(port='/dev/ttyACM0', baud=9600, duration_sec=10, csv_filename=None):
    ser = serial.Serial(port, baud, timeout=1)
    satellites_in_fix = set()
    sat_data = {}

    TALKER_IDS = ["GP", "GL", "GA", "BD", "GB", "QZ", "IR", "SB", "GN"]

    start_time = time.time()
    while time.time() - start_time < duration_sec:
        line = ser.readline().decode(errors='ignore').strip()
        if any(line.startswith(f"${tid}GSA") for tid in TALKER_IDS):
            satellites_in_fix = parse_gsa(line)
        elif any(line.startswith(f"${tid}GSV") for tid in TALKER_IDS):
            sat_data.update(parse_gsv(line))
        time.sleep(0.05)

    # Save results to CSV
    if csv_filename is None:
        csv_filename = f"gnss_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"

    with open(csv_filename, mode='w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["PRN", "Constellation", "SNR", "Elevation", "Azimuth"])
        for prn in sorted(satellites_in_fix, key=lambda x: int(x)):
            info = sat_data.get(prn, {"elevation": "N/A", "azimuth": "N/A", "snr": "N/A"})
            writer.writerow([prn, prn_to_constellation(prn), info["snr"], info["elevation"], info["azimuth"]])

    print(f"Data saved to {csv_filename}")

# ------------------- Run -------------------
if __name__ == "__main__":
    get_satellite_snr(port='/dev/ttyACM0', baud=9600, duration_sec=10)
