import nibabel as nib
import numpy as np
import os
import cv2
from tqdm import tqdm
import random

import matplotlib.pyplot as plt



DATASET_ROOT = "/mnt/neverland/ATLAS"
OUT_DATASET = "/mnt/neverland/itzo/film/dataset"

patients = os.listdir(DATASET_ROOT)

for i in tqdm(range(len(patients))):

    

    patient_path = os.path.join(DATASET_ROOT, patients[i])
    
    sequences = os.listdir(patient_path)

    for seq in sequences:
        if seq.endswith("T1w.nii.gz"):
            break
    
    # print(seq)
    seq_path = os.path.join(patient_path, seq)
    scan = nib.load(seq_path).get_fdata()


    indexes = random.sample(range(1, scan.shape[2]-1), 5)
    
    for triple_index in indexes:
        # print(triple_index)

        try:
            triple_path = os.path.join(OUT_DATASET, patients[i], "triple_" + str(triple_index))
            os.makedirs(triple_path, exist_ok=True)
            frame_idx = 0
            for w in range(triple_index - 1, triple_index + 2):
                # slice = cv2.resize(scan[:, :, w], (512, 512))
                slice = cv2.resize(scan[:, :, w], (512, 512))
                slice_uint8 = cv2.normalize(slice, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)
                slice_rgb = cv2.cvtColor(slice_uint8, cv2.COLOR_GRAY2RGB)
                # slice_new = np.zeros((256,256,3))
                # slice_new[:, :, 0] = slice
                out_path = os.path.join(triple_path, f"img_{frame_idx}.png")
                cv2.imwrite(out_path, slice_rgb)
                # plt.figure()
                # plt.imshow(slice)
                # plt.axis('off')
                # plt.show()
                # plt.savefig(os.path.join(triple_path, f"img_{frame_idx}.png"), format='png', dpi=300)
                # plt.close()
                frame_idx += 1
        except OSError as e:
            print("Error:", e)
            continue


    

    


