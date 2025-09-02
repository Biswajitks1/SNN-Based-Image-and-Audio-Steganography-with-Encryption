# SNN-Based-Image-and-Audio-Steganography-with-Encryption

## Overview  
This project presents a **hardware-efficient steganography framework** that hides audio data inside images using a novel **Spiking Neural Network (SNN)-inspired encoding** combined with **FPGA acceleration**.  

The design was implemented on the **PYNQ-Z2 board**, with custom IP cores for encryption/decryption, integrated via AXI DMA. The system achieves **real-time audio embedding and extraction**, ensures **lossless recovery**, and maintains **imperceptible visual quality** of images.  

---

## Innovation  
- Combines **SNN-inspired spike pattern encoding** with **FPGA-based steganography**.  
- Uses **Leaky Integrate-and-Fire neurons** to map digits into spike-based encrypted representations.  
- Embedding capacity of **8 bits per pixel**, higher than conventional LSB methods (≤5 bits/pixel).  
- Lightweight dithering ensures **visual imperceptibility** of embedded audio.  
- Novel remainder–key encryption scheme improves **security and robustness**.  

---

## Design Complexity  
- End-to-end pipeline:  
  **Audio digitization → SNN mapping → Encryption → Embedding → Decryption → Audio reconstruction**.  
- Custom FPGA IPs:  
  - Digit Extractor (Binary → BCD conversion using Double Dabble)  
  - Encryption Logic (mod-16 + key generation)  
  - Noise generator & LSB embedder  
  - Decryptor with nested search across spike patterns  
- Full-HD image (1920×1080 RGBA) support with **parallelized AXI DMA streaming**.  
- Integration of **software simulation (NEST)** with **hardware acceleration (PYNQ)**.  

---

## Implementation  
- Real-time execution on **PYNQ-Z2** with AXI DMA-based dataflow architecture.  
- **Encryptor Utilization**: ~10% LUT, lightweight.  
- **Decryptor Utilization**: ~65% LUT, resource-heavy but functional.  
- Achieves **lossless audio reconstruction** with no audible or visual degradation.  
- Demonstrated on **1920×1080 images** and arbitrary audio clips.  
- Scalable to **higher resolutions (4K) and video streams** with optimization.  

---

## Reusability  
- **Reusable IP cores** for digit extraction, LSB embedding, and decryption.  
- Encryption logic can be adapted for other media formats (video, text).  
- Framework can act as a **general-purpose hardware steganography platform**.  
- Encourages **further research in neuromorphic-inspired cryptography and FPGA acceleration**.  

---

## Results  
- **Imperceptible visual difference** between original and encrypted images.  
- **Perfectly reconstructed audio** at the receiver.  
- FPGA resource utilization:  
  - Encryptor: ~10% LUT  
  - Decryptor: ~65% LUT  

---

## Authors  
- Biswajit Kumar Sahoo  
- Dr. Pedro Machado  
- Dr. Srinivas Boppu  
