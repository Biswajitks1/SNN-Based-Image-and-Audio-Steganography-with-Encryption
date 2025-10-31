import matplotlib.pyplot as plt
import numpy as np
import nest

# Reset the NEST kernel
nest.ResetKernel()
nest.set_verbosity(20)  # Set NEST verbosity level to 20

# Initialize variables and lists
currents = []  # List to store input currents
spike_counts = []  # List to store spike counts
min_current = 0  # Variable to store the minimum current
inc = 1.0  # Increment value for increasing the current
current = 370.0  # Initial current value
num_spikes = 0  # Variable to store the number of spikes
neuron_params = {
    'C_m': 250.0,       # Membrane capacitance (pF)
    'tau_m': 10.0,      # Membrane time constant (ms)
    't_ref': 2.0,       # Refractory period (ms)
    'E_L': 0.0,         # Resting membrane potential (mV)
    'V_th': 20.0,       # Threshold potential (mV)
    'V_reset': 10.0,    # Reset potential (mV)
    'tau_syn_ex': 0.5,  # Excitatory synaptic time constant (ms)
    'tau_syn_in': 0.5,   # Inhibitory synaptic time constant (ms)
    'Ca': 0.0,
    'V_m': -70.0        
}

# List to store current and spike count pairs where number of spikes increased
current_spikes_values = [[0, 0]]
current_spikes_idx = 0  # Index for current_spikes_values list
actual_number_spikes = 0  # Actual number of spikes observed
number_spikes = 0  # Number of spikes observed

while len(current_spikes_values) < 10:
    nest.ResetKernel()
    neuron = nest.Create('iaf_psc_alpha', params = neuron_params)
    spike_recorder = nest.Create('spike_recorder')

    # Connect the neuron to the spike recorder
    nest.Connect(neuron, spike_recorder)

    # Set the input current to the neuron
    nest.SetStatus(neuron, {'I_e': current})

    nest.Simulate(60.0)

    # Get the number of spikes recorded by the spike recorder
    num_spikes = nest.GetStatus(spike_recorder, 'n_events')[0]

    # Get spike times
    events = spike_recorder.get("events")
    senders = events["senders"]
    ts = events["times"]

    currents.append(current)
    spike_counts.append(num_spikes)

    # Record the current and spike count if the number of spikes increased
    if num_spikes == 0 and current > current_spikes_values[0][0]:
        current_spikes_values[0][0] = current
        print("The current is:",current)
        print("The senders are:",senders)
        print("The time is:",ts)
    elif num_spikes > actual_number_spikes:
        current_spikes_values.append([current, num_spikes])
        print("The current is:",current)
        print("The senders are:",senders)
        print("The time is:",ts)
        actual_number_spikes = num_spikes
        print("For", current, "the number of spikes is", num_spikes)



    current += inc

# Print the result
print("Result:", current_spikes_values)

# Save the current_spikes_values as npy file
np.save('NEST_output/current_spikes_values.npy', current_spikes_values)

# Ranges for same current
ranges = []
for i in range(len(current_spikes_values) - 1):
    low = current_spikes_values[i][0]
    high = current_spikes_values[i + 1][0] - inc
    ranges.append((low, high))

ranges[0] = ('..', ranges[0][1])
ranges.append((current_spikes_values[-1][0], '..'))

print("\nCurrent ranges where spike count is same:")
for i, (low, high) in enumerate(ranges):
    print(f"Spike count {i}: Current range = ({low}, {high})")

# Plot the number of spikes for different increments
plt.plot(currents, spike_counts, marker='o')
plt.title('Number of Spikes vs. Input Current')
plt.xlabel('Input Current (pA)')
plt.ylabel('Number of Spikes')
plt.grid(True)
plt.show()
