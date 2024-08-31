# 実行時に注意すること

## Error
### name '_C' is not defined
* GroundingDINO/setup.py build と　GroundingDINO/setup.py installを実行しないとCUDAに対応できない
* https://github.com/IDEA-Research/Grounded-Segment-Anything/issues/15#issuecomment-1501625063

### 一回テンソルをCPUに移さないと計算できない
* RUN the Segmentation Modelで mask_image = mask.cpu().reshape(h, w, 1) * color.reshape(1, 1, -1)
* .cpu()を追加