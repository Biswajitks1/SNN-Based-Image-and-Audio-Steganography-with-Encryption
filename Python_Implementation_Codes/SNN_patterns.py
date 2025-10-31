import matplotlib.pyplot as plt
import numpy as np
import nest
import math
import csv

# Reset the NEST kernel
nest.ResetKernel()
nest.set_verbosity(20)  # Set NEST verbosity level to 20

# Initialize variables and lists
currents = []  # List to store input currents
spike_counts = []  # List to store spike counts
neuron_params = {
    'C_m': 250.0,       # Membrane capacitance (pF)
    'tau_m': 10.0,      # Membrane time constant (ms)
    't_ref': 2.0,       # Refractory period (ms)
    'E_L': 0.0,         # Resting membrane potential (mV)
    'V_th': 20.0,       # Threshold potential (mV)
    'V_reset': 10.0,    # Reset potential (mV)
    'tau_syn_ex': 0.5,  # Excitatory synaptic time constant (ms)
    'tau_syn_in': 0.5,  # Inhibitory synaptic time constant (ms)
    'Ca': 0.0,
    'V_m': -70.0        
}

current_spikes_values = np.load('NEST_output/current_spikes_values.npy')
chosen_currents = [current_spikes_values[i][0] for i in range(len(current_spikes_values))]

print("\nChosen 10 current values (one from each range):")
print(chosen_currents)

output_array = np.zeros((10, 61), dtype=int)

for idx, current in enumerate(chosen_currents):
    nest.ResetKernel()
    neuron = nest.Create('iaf_psc_alpha', params=neuron_params)
    spike_recorder = nest.Create('spike_recorder')
    nest.Connect(neuron, spike_recorder)
    nest.SetStatus(neuron, {'I_e': current})
    nest.Simulate(60.0)

    ts = spike_recorder.get("events")["times"]
    ts_floored = [int(math.floor(t)) for t in ts if t <= 60.0]

    for t in ts_floored:
        if 0 <= t <= 60:
            output_array[idx][t] = 1
        else:
            print("ts_floored exceeds simulation time ---- some issue")

# Save to CSV
csv_filename = "NEST_output/normalized_matrix.csv"
with open(csv_filename, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(output_array)

print(f"\nSaved to: {csv_filename}")