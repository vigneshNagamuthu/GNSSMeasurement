import serial

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
while True:
    line = ser.readline().decode(errors='ignore').strip()
    if line:
        print(line)
