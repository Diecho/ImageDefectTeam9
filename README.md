# ImageDefectTeam9 — Image-Based Defect Detection for Metal Parts

A MATLAB inspection pipeline that classifies metal-plate images as PASS or FAIL using a hybrid workflow: image processing generates a red overlay, and a transfer-learned ResNet-18 makes the final decision by categorizing the part into one of four specific defect types. 

## Objective

Build a virtual inspection station for a single part type (metal plates) that:
1. Standardizes and preprocesses each image (resize, illumination correction, denoising).
2. Extracts an evidence overlay and interpretable metrics (rust regions, scratches, area ratio).
3. Classifies the part with a fine-tuned CNN (`resnet18`) into `good`, `scratches`, `major_rust`, or `total_rust`, then collapses to PASS/FAIL.
4. Evaluates accuracy on a held-out test set (confusion matrix, yield/defect rates).
5. Tests robustness under simulated lighting, blur, and noise variations.

The full technical write-up, including all plots, confusion matrices, and analytics, is available in the project report:

[![View PDF](https://img.shields.io/badge/View_Report-PDF-red.svg)](MetalPlatesImageBasedDefectSystem.pdf)

## Requirements

- **MATLAB R2023a or newer** (tested on R2026a)
- Toolboxes:
  - Image Processing Toolbox
  - Deep Learning Toolbox
  - Deep Learning Toolbox Model for ResNet-18 Network (Add-On)
> **Heads up:** The ResNet-18 model isn't included in base MATLAB. If you don't have it installed yet, MATLAB should automatically prompt you to download it when you run the script. You can also just search for "ResNet-18" in the Add-On Explorer and grab it there.

## Repository Layout

```
ImageDefectTeam9/
├── metal_plate/                              # MPDD image dataset and generated CSV
│   ├── ground_truth/                         # Ground-truth defect masks (not used)
│   ├── test/                                 # Testing images (good, major_rust, scratches, total_rust)
│   └── train/                                # Training images (good only)
├── models/                                   # Trained Machine Learning models
│   ├── MyBestNet.mat                         # Best trained ResNet-18 model (used by default)
│   └── trainedNet.mat                        # Default save file for custom training runs
├── functions/                                # All custom image processing & AI functions
│   └── *.m                                   # Pipeline functions (see detailed descriptions below)
├── MetalPlatesImageBasedDefectSystem.mlx     # Main Live Script containing all tasks and report
├── MetalPlatesImageBasedDefectSystem.pdf     # Exported PDF report
├── README.md                                 # Project documentation
└── .gitignore                                # Git ignore file (*.asv)
```

## How to Run and Reproduce Results

Follow these exact steps to run the Live Script and reproduce our results:

**1. Set Up the Dataset (Task 1)**
* Open `MetalPlatesImageBasedDefectSystem.mlx` in MATLAB.
* Locate the `root` variable in **Task 1** and change the file path to match the location of the repository on your local computer.
* **CRITICAL:** Uncomment the code block under *Generating the CSV* and run that section once. This will scan your local folders and generate the required `labels.csv` file. Once the CSV is created, you can comment that block out again.

**2. Install Dependencies**
* If you do not have the ResNet-18 Add-On installed, running the script for the first time will automatically prompt you to download it. 

**3. Choose Your Training Path (Task 3)**

When you reach the **Network Training** section in Task 3, you have two options:
* **Option A: Use our Pre-Trained Model (Recommended)** Leave the code as-is to load `MyBestNet.mat`. This instantly loads our best performing AI model so you can immediately run Tasks 4 and 5 to see the final analytics.
* **Option B: Train from Scratch**
  If you want to verify our training process, uncomment the `trainNetwork()` line. **Note:** Training takes about 5 minutes on a standard CPU. MATLAB can utilize an NVIDIA GPU to make this significantly faster, though our team solely utilized CPU training for this project. If you train a new network, be sure to uncomment the `save()` function if you want to keep your results!

**4. Run Evaluations (Tasks 4 & 5)**
* Once your model is loaded (or trained), simply run the remaining sections of the script to generate the Pass/Fail confusion matrices, the factory yield analytics, and the simulated stress-tests.

## File Descriptions

### Core Pipeline (/functions)
- **`standardizeImage.m`** — Resizes and formats input images to a uniform size (512×512).
- **`correctLighting.m`** — Corrects uneven illumination, contrast, and noise.
- **`segmentPart.m`** — Separates the metal plate from the background.
- **`defectEvidence.m`** — Generates binary defect masks for rust based on color and scratches based on edges.
- **`extractMetrics.m`** — Calculates defect metrics: number of components, largest component area, and area ratio.
- **`decideRules.m`** — Applies simple thresholds to decide PASS or FAIL.
- **`classify.m`** — Passes the image region to our trained network model to get the defect label and confidence score.
- **`inspectPart.m`** — Main single-image inspection, combines image processing and AI predictions.
- **`runInspectionSuite.m`** — Runs a full dataset of testing images and collects accuracy metrics.
- **`applyBlur.m`** — Gaussian blur (defocus simulation), `sigma` parameter.
- **`applyContrast.m`** — Gamma correction to simulate over/under-exposed lighting.
- **`applyNoise.m`** — Adds `gaussian`, `salt & pepper`, or `speckle` sensor noise.

### Models (/models)
- **`MyBestNet.mat`** — Our best pre-trained ResNet-18 model (used by default).
- **`trainedNet.mat`** — A pre-trained network kept for testing or for people who want to explore other training options.
  
### Data
- **`metal_plate/`** — MPDD subset with `train/`, `test/`, `ground_truth/`, and `labels.csv`.

## Dataset & Licensing

**Code License**
The software and code in this repository are licensed under the MIT License (see the `LICENSE` file for details).

**Dataset License**
This project uses the **Metal Parts Defect Detection Dataset (MPDD)** by Jezek et al. — [stepanje/MPDD on GitHub](https://github.com/stepanje/MPDD).

Images are used under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

### Citation
> S. Jezek, M. Jonak, R. Burget, P. Dvorak, and M. Skotak, "Deep learning-based defect detection of metal parts: evaluating current methods in complex conditions," *2021 13th International Congress on Ultra Modern Telecommunications and Control Systems and Workshops (ICUMT)*, 2021, pp. 66–71, doi: 10.1109/ICUMT54235.2021.9631567.
