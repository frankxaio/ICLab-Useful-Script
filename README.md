Fork from https://github.com/JyunWei-Su/ICLab-Useful-Srcipt

## Install

```sh
cd $HOME/Downloads/
curl -O https://raw.githubusercontent.com/frankxaio/ICLab-Useful-Srcipt/main/install.sh
```

```sh
bash install.sh
```

>   [!WARNING]
>
>   請先備份好自己的 `.tcshrc` 再進行安裝，
>
>   ![image-20251203011140626](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203011140626.png)
>
>


## 使用方法

使用任何指令之前都必須先設定 project root path

```sh
$ prj
```

![image-20251203010852237](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203010852237.png)

### 快速切換資料夾，支援1_XXX~99_XXX

![image-20251203010215628](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203010215628.png)



### 快速修改 clock period

-   輸入 c 查看目前 `clk` 設定
-   輸入 c peroid修改並顯示 `clk`

![image-20251203011022952](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203011022952.png)



### 一鍵開啟/關閉 fsdb

-   輸入 f 查看目前 `fsdb` 設定

-   輸入 f rtl on/off修改並顯示 `rtl fsdb` 設定

-   輸入 f gate on/off修改並顯示 `gate fsdb` 設定

-   輸入 f post on/off修改並顯示 `post fsdb` 設定
-   輸入 f on 開啟 `rtl, gate, post fsdb` 設定
-   輸入 f off 關閉 `rtl, gate, post fsdb` 設定

![image-20251203011606429](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203011606429.png)

### 一鍵開啟 User guide

-   輸入 `doc_dw` 開啟 DesignWare IP

-   輸入 `doc_io` 開啟 IO Pdf
-   輸入 `doc_verdi` 開啟 Verdi ug
-   輸入 `doc_soc` 切換到 INNOVUS user guide 資料夾
-   ...



### 快速模擬 RTL, SYN, GATE, POST

-   輸入 `rtl` 執行 rtl simulation
-   輸入 `syn` 執行 synthesis
-   輸入 `gate` 執行 gate-level simulation
-   輸入 `post` 執行 post simulation

![image-20251203012543088](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203012543088.png)

### 快速檢查合成結果

-   輸入 `check_syn` 檢查合成結果
-   輸入 `rpt` 查看有哪些 report
-   輸入 `rpt timing`, `rpt power`,.. 查看各種 report



![image-20251203015352699](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203015352699.png)

![image-20251203015450957](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203015450957.png)

![image-20251203015558913](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203015558913.png)



### 快速檢查 vcs.log syn.log

-   在 01_RTL 輸入 `check_warn` 檢查 vcs.log
-   在 02_SYN 輸入 `check_warn` 檢查 syn.log

![image-20251203014157897](https://raw.githubusercontent.com/frankxaio/markdwon-image/main/data/image-20251203014157897.png)



## TODO
- [ ] Save current rtl, synthesis result
- [ ] Add more quick open userguid
- [ ] `lib2db` built in method