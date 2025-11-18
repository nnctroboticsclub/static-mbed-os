# StaticMbedOS


MbedOS のフォーク MbedCE を静的ライブラリに固めたパッケージを作成するコード群です。

## メンテについて

このリポジトリのメンテナンスはこれ以上行われません。
後続の [roboenv-nix](https://github.com/nnctroboticsclub/roboenv-nix) プロジェクトをご覧ください。

## ビルド (Nix)

```sh
nix build .#static-mbed-os-f446re .#static-mbed-os-f303k8
```

## 使い方

CMake プロジェクトが前提になります
static-mbed-os の出力する CMake Toolchain ファイルを読み込むと、 StaticMbedOS ターゲットが定義されるので、それをリンクします。

```sh
cmake -S ... -B ... \
  -DCMAKE_TOOLCHAIN_FILE=(...)/StaticMbedOSToolchain-NUCLEO_F446RE
```

```cmake
cmake_minimum_required(VERSION 3.19)

project(TheProject)

add_executable(TheExecutable main.cpp)
target_link_libraries(TheExecutable PUBLIC
  StaticMbedOS
)
static_mbed_os_app_target(TheExecutable)
```
