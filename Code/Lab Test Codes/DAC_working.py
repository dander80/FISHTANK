import time
import board
import busio
import adafruit_mcp4728

# Specify SDA and SCL pins for I2C bus 1
sda_pin = 3
scl_pin = 5

# Initialize I2C bus
i2c = busio.I2C(board.SCL, board.SDA)

# Initialize MCP4728 DAC
mcp4728 = adafruit_mcp4728.MCP4728(i2c)

# Set DAC values
mcp4728.channel_a.value = int(65535 / 10)
mcp4728.channel_b.value = int(65535 / 3)
mcp4728.channel_c.value = int(65535 / 7)
mcp4728.channel_d.value = int(65535 * 5 / 5.323)

# Wait for a moment to ensure settings are applied
time.sleep(0.5)

print("DAC values set successfully.")
