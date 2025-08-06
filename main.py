from find_lat_long import find_gps_loc
from sat_connected import get_satellite_snr

PORT = "/dev/ttyACM0"

# Get fixed location
gps_data = next(find_gps_loc(PORT))

print(
    f"\n Location: Latitude = {gps_data['latitude']}, Longitude = {gps_data['longitude']}, "
    f"Fix Quality = {gps_data['fix_quality']}, Number of Satellites = {gps_data['num_satellites']}\n"
)
# Get satellite + SNR info
for prn, snr, elev, azim in get_satellite_snr(PORT):
    print(f"  PRN {prn}: SNR = {snr}, Elevation = {elev}, Azimuth = {azim}")
