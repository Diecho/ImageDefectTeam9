# ImageDefectTeam9 — Image-Based Defect Detection for Metal Parts

A MATLAB inspection pipeline that classifies metal-plate images as **PASS** or **FAIL** using a hybrid workflow: classical image processing generates traceable defect evidence, and a transfer-learned ResNet-18 makes the final decision.

## Objective

Build a virtual inspection station for a single part type (metal plates) that:
1. Standardizes and preprocesses each image (resize, illumination correction, denoising).
2. Extracts an **evidence overlay** and interpretable metrics (rust regions, scratches, area ratio).
3. Classifies the part with a fine-tuned CNN (`resnet18`) into `good`, `scratches`, `major_rust`, or `total_rust`, then collapses to PASS/FAIL.
4. Evaluates accuracy on a held-out test set (confusion matrix, yield/defect rates).
5. Tests robustness under simulated lighting, blur, and noise variations.

Full write-up with plots and confusion matrices is in [MetalPlatesImageBasedDefectSystem.pdf](MetalPlatesImageBasedDefectSystem.pdf).

## Requirements

- **MATLAB R2023a or newer** (tested on R2024a)
- Toolboxes:
  - Image Processing Toolbox
  - Deep Learning Toolbox
  - Statistics and Machine Learning Toolbox
  - Deep Learning Toolbox Model for ResNet-18 Network (Add-On)

## Repository Layout

```
ImageDefectTeam9/
├── ImageBasedDefectSystem_StudentProjectTemplate.mlx  # Main Live Script
├── ImageBasedDefectSystem_StudentProjectTemplate.pdf  # Exported report of the Live Script
├── MyBestNet.mat                                      # Best trained ResNet-18 (used by default)
├── trainedNet.mat                                     # Additional trained network snapshot
├── metal_plate/                                       # MPDD dataset (train/, test/, labels.csv)
└── *.m                                                # Pipeline functions (see below)
```

## How to Run

1. Open MATLAB and set the working directory to the repo root.
2. Open [ImageBasedDefectSystem_StudentProjectTemplate.mlx](ImageBasedDefectSystem_StudentProjectTemplate.mlx). This Live Script drives the full workflow (dataset loading, training, evaluation, and robustness tests). Run it section-by-section.
3. To run inference on a single image with the pre-trained network:
   ```matlab
   load('MyBestNet.mat');   % loads variable `net`
   I = imread('metal_plate/test/scratches/000.png');
   [label, conf, overlay, metrics, baseline] = inspectPart(I, net);
   imshow(overlay); title(sprintf('%s (%.2f) — baseline: %s', label, max(conf), baseline));
   ```
4. To run the full batch evaluation on the test set:
   ```matlab
   load('MyBestNet.mat');
   imds = imageDatastore('metal_plate/test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   results = runInspectionSuite(imds, net);
   confusionchart(results.trueLabel, results.aiPred);
   ```
5. Robustness sweeps: pass a distortion handle as the third argument, e.g.
   ```matlab
   results = runInspectionSuite(imds, net, @(I) applyBlur(I, 4));
   ```

## Reproducing the Results

- The train/test split used in the report is the one shipped in `metal_plate/train` and `metal_plate/test`.
- Use `MyBestNet.mat` to reproduce the reported accuracy without retraining.
- To retrain: run the training section of the Live Script (transfer learning on `resnet18`, image size 224×224). Set a fixed `rng(0)` before `trainNetwork` if you want deterministic weights.
- To reproduce robustness numbers, call `runInspectionSuite` with each of the distortion functions and the sweep values noted in the function help comments (`applyBlur` sigma ∈ [1 2 4 8], `applyContrast` gamma ∈ [0.4 0.7 1.5 2.5], `applyNoise` with the three noise types).

## File Descriptions

### Pipeline (called per image)
- **`standardizeImage.m`** — Resizes the input and returns both RGB and grayscale copies at a common size (default 512×512).
- **`correctLighting.m`** — Flat-field illumination correction (`imflatfield`), CLAHE contrast normalization, and median denoising.
- **`segmentPart.m`** — Adaptive threshold + hole-fill to isolate the metal part silhouette from the background.
- **`defectEvidence.m`** — Produces the defect evidence mask: HSV hue/saturation gate for rust + Canny edges gated by dark regions for scratches, then morphological cleanup.
- **`extractMetrics.m`** — Computes interpretable metrics from the evidence mask: number of components, largest component area, and area ratio.
- **`decideRules.m`** — Classical rule-based baseline PASS/FAIL decision using thresholds on `areaRatio` and `maxArea`.
- **`inspectPart.m`** — Top-level per-image function that runs the full pipeline and returns `finalLabel`, `confidenceScore`, `evidenceOverlay`, `evidenceMetrics`, and the classical `baselineDecision`.

### Batch evaluation
- **`runInspectionSuite.m`** — Iterates over an `imageDatastore`, optionally applies a distortion function, calls `inspectPart` on each image, and returns a table with true labels, AI predictions, baseline predictions, agreement tier, and per-image correctness.

### Robustness perturbations (Task 5)
- **`applyBlur.m`** — Gaussian blur (defocus simulation), `sigma` parameter.
- **`applyContrast.m`** — Gamma correction to simulate over/under-exposed lighting.
- **`applyNoise.m`** — Adds `gaussian`, `salt & pepper`, or `speckle` sensor noise.

### Models & data
- **`MyBestNet.mat`** — Fine-tuned ResNet-18 used for the reported results (loads variable `net`).
- **`trainedNet.mat`** — Earlier training snapshot kept for comparison.
- **`metal_plate/`** — MPDD subset with `train/`, `test/`, `ground_truth/`, and `labels.csv`.

## Dataset & Licensing

This project uses the **Metal Parts Defect Detection Dataset (MPDD)** by Jezek et al. — [stepanje/MPDD on GitHub](https://github.com/stepanje/MPDD).

### License
Images are used under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

### Citation
> S. Jezek, M. Jonak, R. Burget, P. Dvorak, and M. Skotak, "Deep learning-based defect detection of metal parts: evaluating current methods in complex conditions," *2021 13th International Congress on Ultra Modern Telecommunications and Control Systems and Workshops (ICUMT)*, 2021, pp. 66–71, doi: 10.1109/ICUMT54235.2021.9631567.
