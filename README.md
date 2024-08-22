# エラー解決
### git-lsf
* git-lfsを使ってモデルをダウンロードするのはダメっぽいので、手作業でDLし配置する
* git lfs pullは上手くいかない
* models/AnimeInstanceSegmentation/refine_last.ckpt
* （refin-netをモデルで使用している）
* refine-netを外すと精度が落ちる
* （今回は一応、rtmdetl_e60.ckptもDLしている）

### UserWarning: torch.meshgrid: in an upcoming release, it will be required to pass the indexing argument. (Triggered internally at ../aten/src/ATen/native/TensorShape.cpp:3526.) return _VF.meshgrid(tensors, **kwargs)  # type: ignore[attr-defined]
* 自分のpytorchのバージョンが、作成環境より新しいとNoticeされる

# その他
### ソースコードを読むの大事
* 解説ブログを信じていたが、ソースコードを辿っていくとブログでDLと紹介されていたファイル名が違うことに気づく
* そこを治したら解決した