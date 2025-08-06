import serial
import time

def parse_gsa(line):
    parts = line.split(',')
    return set(p for p in parts[3:15] if p)

# ------------------------------------------------------------------------
def parse_gsv(line):
    parts = line.split(',')
    sat_info = {}
    # iterate every group of 4 fields (PRN, Elev, Azimuth, SNR)
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

#------------------------------------------------------------------------
def get_satellite_snr(port='/dev/ttyACM0', baud=9600):
    ser = serial.Serial(port, baud, timeout=1)
    satellites_in_fix = set()
    sat_data = {}  # stores elevation, azimuth, snr per PRN

    for _ in range(100):
        line = ser.readline().decode(errors='ignore').strip()
        if line.startswith(('$GPGSA', '$GLGSA', '$GNGSA', '$GAGSA')):
            satellites_in_fix = parse_gsa(line)
        elif line.startswith(('$GPGSV', '$GLGSV', '$GNGSV', '$GAGSV')):
            sat_data.update(parse_gsv(line))
        time.sleep(0.1)

    if satellites_in_fix:
        for prn in satellites_in_fix:
            info = sat_data.get(prn, {"elevation": "N/A", "azimuth": "N/A", "snr": "N/A"})
            yield prn, info["snr"], info["elevation"], info["azimuth"]
