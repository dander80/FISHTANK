#%% IMPORTS
import numpy as np
import matplotlib.pyplot as plt
import json
from scipy.integrate import odeint
#%%

# conversions 
m_per_inch = 0.0254 # 1 in = 0.0254 m
kg_per_gal_H2O = 3.7854 



# Parameters
a_tank  = 0.1824 # [m^2]
r_pipe  = .75*m_per_inch # [m]
a_pipe  = np.pi * r_pipe**2 # [m^2]
density = 998 # [kg/m^3]
H_tank  = 0.762 # [m]
H_pipe  = 0.1 # [m]
L_pipe  = 0.5 # [m]
g       = 9.81 # [m/s^2]

# variables 
tank1_level   = 0
tank2_level   = 0
mdot_1_in     = 0
mdot_2_in     = 0
mdot_1_out    = 0
mdot_2_out    = 0
mdot_between  = 0
f_CV          = 1.0 # factor to account for oppeness of the connection valve
CV_1_signal   = 1.0 # make both CV's start fully open
CV_2_signal   = 1.0 # make both CV's start fully open
mdot_1_in     = 20 
mdot_2_in     = 20 
#%% DEFINE DESIRED POSITIONS

desired_position = []

tank1_position_setpoint = {
    'time':     [0,   100, 200, 300, 400, 500],
    'position': [0.5, 0.5, 0.5, 0.5, 0.8, 0.8]
}

tank2_position_setpoint = {
    'time':     [0,   100, 200, 300, 400, 500],
    'position': [0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
}

desired_position.append(tank1_position_setpoint)
desired_position.append(tank2_position_setpoint)


### INFO ON HOW TO LOAD JSON ###
    # # Load JSON data from a file
    # with open('data.json', 'r') as file:
    #     data = json.load(file)

    # # Accessing JSON data
    # print(data['key1'])
    # print(data['key2']['nested_key'])

plt.figure()
plt.plot(tank1_position_setpoint['time'], tank1_position_setpoint['position'], label = 'tank 1 setpoint')
plt.plot(tank2_position_setpoint['time'], tank2_position_setpoint['position'], label = 'tank 2 setpoint')
plt.legend()
plt.show()


#%% main loop

mdot_between_values   = []
mdot_1_out_values   = []
mdot_2_out_values   = []

def model(tank_levels, t, a_tank, a_pipe, density, g, mdot_1_in, mdot_2_in):
    a_tank  = 0.1824 # [m^2]
    a_pipe  = np.pi * r_pipe**2 * .35 # [m^2]
    density = 998 # [kg/m^3]
    g       = 9.81 # [m/s^2]

    # delta_H = tank_levels[1] - tank_levels[0] 

    mdot_between = density * (np.sqrt(2*g*tank_levels[1]) - np.sqrt(2*g*tank_levels[0])) * a_pipe * f_CV
    mdot_1_out = density * np.sqrt(2*g*tank_levels[0]) * a_pipe
    mdot_2_out = density * np.sqrt(2*g*tank_levels[1]) * a_pipe

    dH1dt = (mdot_1_in(t) + mdot_between - mdot_1_out) / (density * a_tank)
    dH2dt = (mdot_2_in(t) - mdot_between - mdot_2_out) / (density * a_tank)
    # print('mdot_1_out = ', mdot_1_out)
    mdot_between_values.append(mdot_between)
    mdot_1_out_values.append(mdot_1_out)
    mdot_2_out_values.append(mdot_2_out)
    return [dH1dt, dH2dt, mdot_between, mdot_1_out, mdot_2_out]

base_mdot_in = 1.26 # [kg/s] to both tanks

def mdot_1_in(t):
    # return 1*base_mdot_in if t < 250 else 0.4*base_mdot_in
    return 1*base_mdot_in

def mdot_2_in(t):
    return 1*base_mdot_in

init_tank_levels = [0, 0, 0, 0, 0]

t = np.linspace(0, 2000, 2000)  # time from 0 to 20, 100 points

tank_levels = odeint(model, init_tank_levels, t, args=(a_tank, a_pipe, density, g, mdot_1_in, mdot_2_in))

# Plot the results
plt.figure()
plt.plot(t, tank_levels[:, 0], label='tank 1 height')
plt.plot(t, tank_levels[:, 1], label='tank 2 height')
plt.hlines(H_tank, xmin=0, xmax=max(t), colors='r', linestyles='dashed', label='tank height')
plt.xlabel('Time')
plt.ylabel('tank levels [m]')
plt.legend()
plt.grid(True)
plt.show()

####

# mdot_between_values = tank_levels[:, 2]
# mdot_1_out_values = tank_levels[:, 3]
# mdot_2_out_values = tank_levels[:, 4]

# Plot mdot_between, mdot_1_out, and mdot_2_out
plt.plot(t, mdot_between_values, label='mdot_between') 
plt.plot(t, mdot_1_out_values, label='mdot_1_out') 
plt.plot(t, mdot_2_out_values, label='mdot_2_out') 
plt.xlabel('Time')
plt.ylabel('Flow Rate [kg/s]')
plt.title('Flow Rates Over Time')
plt.legend() 
plt.grid(True) 
plt.show() 

#%% example code for write json file

# data = []
# for i in range(........):
#     step_data = {
#         'time': tank1_levels[i],
#         'tank1_level': tank1_levels[i],
#         'tank2_level': tank2_levels[i],
#         'mdot_tank1_out': mdot_tank1_out[i],
#         'mdot_tank2_out': mdot_tank2_out[i],
#         'CV1_position': CV1_position[i],
#         'CV2_position': CV2_position[i], 
#         'CV1_command': CV1_command[i],
#         'CV2_command': CV2_command[i]
#     }
#     data.append(step_data)

# # Write JSON data to a file
# with open('output.json', 'w') as file:
#     json.dump(data, file, indent=4)




#%% example code for SOLVING ODE'S
# Define the function representing the ODE dy/dt = f(y, t)
def model(y, t):
    k = 0.1  # example constant
    dydt = -k * y  # example differential equation
    return dydt 

# Initial condition
y0 = 5.0

# Time points
t = np.linspace(0, 20, 100)  # time from 0 to 20, 100 points

# Solve the ODE
y = odeint(model, y0, t)

# Plot the results
plt.plot(t, y)
plt.xlabel('Time')
plt.ylabel('y(t)')
plt.title('Solution of the ODE dy/dt = -ky')
plt.grid(True)
plt.show()
 
#%%