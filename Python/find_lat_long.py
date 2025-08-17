import serial
import pynmea2

def find_gps_loc(port, baud=9600):
    with serial.Serial(port, baud, timeout=1) as ser:
        while True:
            line = ser.readline().decode('ascii', errors='replace').strip()
            if line.startswith('$GPGGA') or line.startswith('$GNGGA') or line.startswith('$GLGGA'):
                try:
                    msg = pynmea2.parse(line)
                    # Extract data from GGA sentence
                    latitude = msg.latitude
                    longitude = msg.longitude
                    fix_quality = msg.gps_qual    # 0 = invalid, 1 = GPS fix, 2 = DGPS fix
                    num_satellites = msg.num_sats
                    hdop = msg.horizontal_dil
                    altitude = msg.altitude
                    geoid_height = msg.geo_sep
                    yield {
                        'latitude': latitude,
                        'longitude': longitude,
                        'fix_quality': fix_quality,
                        'num_satellites': num_satellites,
                        'hdop': hdop,
                        'altitude': altitude,
                        'geoid_height': geoid_height
                    }
                except pynmea2.ParseError:
                    continue