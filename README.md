# ๐ฑ MEMO 

## ๐ ๊ฐ์ ๋ด์ฉ

2022.10.24 > ๊ธฐ์กด ํ์ด๋ธ ๋ทฐ๋ฅผ Compositional Layout + Diffable Datasource๋ก ๋ณ๊ฒฝ

<br>

## ๐ฑ ํ๋ฉด๊ณผ ๊ธฐ๋ฅ, ๊ตฌํ๋ฐฉ์

### ๐ค ์ฐ์ปด ์คํฌ๋ฆฐ 
 `UserDefaults`์์ `Bool`ํ์ ๋ณ์๋ฅผ ์ด์ฉํด ์ฑ ์ฒซ์คํ์ฌ๋ถ๋ฅผ ์ฒดํฌํ๊ณ  ์ฒ์์ผ ๊ฒฝ์ฐ์๋ง ๋ณด์ฌ์ค๋๋ค.
| - ํ์ ํ์ | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 01 54 20](https://user-images.githubusercontent.com/51395335/188351455-41f40215-f24a-40d3-bc50-5bbaa48b51d0.gif) |

<br>

### ๐ ๋ฉ๋ชจ ์์ฑํ๊ธฐ 
1. ๋ฉ๋ชจ ์์ฑ ์ ์ฒซ๋ฒ์งธ ๊ฐํ๋ฌธ์๋ฅผ ๋ฐ๊ฒฌํ๊ธฐ ์ ๊น์ง๋ ํ์ดํ, ์ดํ๋ ์ฝํ์ธ ๋ก ์ ์ฅํฉ๋๋ค. ์๋ฃ๋ฒํผ์ ๋๋ฅด๊ฑฐ๋ ๋ค๋ก๊ฐ๊ธฐ๋ฅผ ๋๋ฅด๋ฉด ์ ์ฅ๋ฉ๋๋ค.
2. ๋ฉ๋ชจ ์์ฑ ์ ํค๋ณด๋์ ๋ฐ ๋ฒํผ์ด ๋ชจ๋ ๋ณด์๋๋ค. 
2. ๋ด์ฉ์ด ์์ผ๋ฉด ์ ์ฅํ์ง ์์ต๋๋ค. 
3. ๊ณต์  ๋ฒํผ์ ๋๋ฅด๋ฉด ์์ฑ๋ ๋ด์ฉ์ด `Activity View` ๋ฅผ ํตํด ๊ณต์ ๋ฉ๋๋ค. (๋ด์ฉ์ด ์์ ๊ฒฝ์ฐ ๊ณต์ ๊ฐ ๋์ง ์์ต๋๋ค.)

| - ๋ฉ๋ชจ ์์ฑํ๊ธฐ   |  - ๋ด์ฉ์ด ์์ผ๋ฉด ์ ์ฅํ์ง ์๊ธฐ    | - ๋ฉ๋ชจ ๊ณต์ ํ๊ธฐ |
|---|---|---|
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 21 04](https://user-images.githubusercontent.com/51395335/188488775-0cb51536-fa66-4f39-98bb-7b56aab3851e.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 16 13 27](https://user-images.githubusercontent.com/51395335/188389038-5925d2d5-3b09-4d33-9631-e8d0d94378e1.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 16 13 56](https://user-images.githubusercontent.com/51395335/188389183-a51f0094-e4ee-4b07-bc93-87400655273e.gif) |

<br>

### ๐ ๋ฉ๋ชจ ์์ ํ๊ธฐ
1. ๋ฆฌ์คํธ์์ ์์ ์ ํํ๋ฉด ์์ ํ๊ธฐ๋ก ๋์ด๊ฐ๊ณ , ํค๋ณด๋์ ๋ฐ ๋ฒํผ์ด ๋ณด์ด์ง ์์ต๋๋ค. 
2. ์์ ์ฐฝ์์ ํ ๋ฒ ๋ ํญํ๋ฉด ํค๋ณด๋์ ๋ฐ ๋ฒํผ์ด ๋ณด์๋๋ค. 

<br>

| -  ๋ฉ๋ชจ ์์  | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 26 30](https://user-images.githubusercontent.com/51395335/188489244-5c807f17-1f5c-487e-a4d8-193ab9816389.gif) |

### ๐งฉ ๋ฉ๋ชจ ๋ฆฌ์คํธ 
1. ์ค๋ ์ค์ ์์ฑ๋ ๋ฉ๋ชจ๋ ์๊ฐ, ์ฃผ์ค์ ์์ฑ๋ ๋ฉ๋ชจ๋ ์์ผ, ๊ทธ ์ธ์๋ ๋์์์ด ์๋ ฅ๋๋๋ก ํฉ๋๋ค. 
2. ๋ฉ๋ชจ์ ๊ฐ์๋ ๋ฐ๋ก ๋ฐ์๋์ ์์ ๋จ๊ฒ ๋ฉ๋๋ค. ๋ง์ฝ 1์ฒ๊ฐ๊ฐ ๋์ ๊ฒฝ์ฐ ์ธ์๋ฆฌ์๋ง๋ค ์ผํ๊ฐ ํ์๋ฉ๋๋ค. 
3. `leadingSwipeAction`์ผ๋ก ๋ฉ๋ชจ๋ฅผ ๊ณ ์ ํ  ์ ์์ต๋๋ค.
4. `trailingSwipeAction`์ผ๋ก ๋ฉ๋ชจ๋ฅผ ์ญ์ ํ  ์ ์์ต๋๋ค. 

<br>

| - ๋ฉ๋ชจ ๋ชฉ๋ก |  -  ์ค์์ดํ์ก์ - ํ ๊ณ ์    | - ์ค์์ดํ์ก์ - ์ญ์ |
|---|---|---|
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 36 14](https://user-images.githubusercontent.com/51395335/188490251-824f7249-d15d-4706-b99c-6ae236a12365.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 33 40](https://user-images.githubusercontent.com/51395335/188490025-7e67b282-492d-432e-9e54-8e3fb55e7da1.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 34 56](https://user-images.githubusercontent.com/51395335/188490145-2f89af7c-a0c2-4622-9c17-dee04adac403.gif)|


### ๐ ๊ฒ์
1. ๊ฒ์์ด์ ์ผ์นํ๋ ๋ฉ๋ชจ๋ฅผ ์ค์๊ฐ์ผ๋ก ๋ณด์ฌ์ค๋๋ค.
2. ์ผ์นํ ๋ฌธ์์ด์ ์๊น์ด ๋ค๋ฅด๊ฒ ํ์๋ฉ๋๋ค. 
3. ๊ฒ์์ฐฝ์์ ๊ฒ์๊ฒฐ๊ณผ๋ฅผ ํด๋ฆญํด๋ ๋ฉ๋ชจ ์์ ํ๊ธฐ ํ๋ฉด์ ๋ณผ ์ ์์ต๋๋ค.

| - ๊ฒ์ํ๋ฉด | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 38 52](https://user-images.githubusercontent.com/51395335/188490539-75b44e2b-4b2b-498e-bc8d-7f785e5dd613.gif) |


<br>


### ๐ญ ๋์๋ณด๋ฉฐ
ํ์์๋ ์ปค๋ฐ์ด๋ ๋ฌธ์, ์ด์์ ์ ํ ์ ๊ฒฝ์ฐ์ง ์์๋๋ฐ, ์ด๋ฒ์๋ ์ต๋ํ ๊ณผ์ ๊ณผ ์ฝ๋์ ์ปค๋ฐ์ ๋จ์๋ฅผ ๋ณด๊ธฐ ์ข๊ฒ ๋ง๋ค๊ณ  ์ถ๋ค๋ ์๊ฐ์ผ๋ก ํ๋ก์ ํธ๋ฅผ ์งํํ์ต๋๋ค.
๋ฏธ๋ฆฌ ์๊ตฌ์ฌํญ์ ์ด์๋ก ์ ๋ฆฌํ๊ณ  ์ปค๋ฐ์ ์๊ฐ ์ชผ๊ฐ๊ณ , ์ด์ ํํ๋ฆฟ๊ณผ PR ํํ๋ฆฟ์ ๋ง๋ค๊ณ  ์ปค๋ฐ ๋ฉ์์ง์๋ ์ ๊ฒฝ์ ์ฐ๊ณ , ํด๋๋ง๊ณผ ์ฃผ์, ๊ตฌํํ๋ฉด์๋ ์ต๋ํ ๋ฐฐ์ด ๊ฐ๋์ ํ์ฉํด๋ณด์๊ณ  ์๊ฐํ๋๋ฐ์. 
์์ํ ์์ฌ์์ ์ฐจ์นํ๊ณ ์๋ผ๋ ๋ฉ๋ชจ ํ๋ก์ ํธ ์์ ์ง์ ์ ๋ฐฐ์ด `Observable` ๊ทธ๋ฆฌ๊ณ  ์ ์ฉํด๋ณด๊ณ  ์ถ์๋ `DiffableDataSource`์ `Compositional Layout`์ ์จ๋ณด์ง ๋ชปํด ํฐ ์์ฌ์์ด ๋จ์ต๋๋ค. 

<br>

---

<br>


### ๐  ๊ฐ์  ๋ฐฉํฅ
0. RX์ MVVM์ ์ด์ฉํด ๊ฐ์ ํ๊ธฐ 
1. ์น์์ ๋๋ฌด ์์กดํ๋ ๋ถ๋ถ: ๊ฒ์์ค์ด ์๋ ๋์๋ ์์ ์น์ 0์ ๊ณ ์ ๋ฉ๋ชจ ์์ญ์ผ๋ก ์ก์๋์๊ธฐ ๋๋ฌธ์, ๊ณ ์ ๋ฉ๋ชจ๊ฐ ์์ ๊ฒฝ์ฐ ์์ ๋น ๊ณต๊ฐ์ด ์ข ๋ ์๊ธด๋ค. ๋ค๋ฅธ ๊ณณ์์๋ ์น์ 0์ ๊ธฐ์ค์ ์ผ๋ก ์ก์๋์๋๋ฐ, ์ด๊ฑธ ๋ฐ์ดํฐ ์ค์ฌ์ผ๋ก ๋ฐ๊ฟ์ผํ  ๊ฒ ๊ฐ๋ค. 
2. ๊ฒ์ ์ฟผ๋ฆฌ์ ์ ์ฉ๋๋ ๋ฌธ์์ด์ ๋ ์ด๋ธ์ ๋ฐ๋ก ์ ์ฉํ  ์ ์๋๋ก `UILabel`์ `extension`์ผ๋ก ํด๋์๋๋ฐ, ์คํ๋ ค ๋ฒ์ฉ์ ์ผ๋ก ์ฌ์ฉํ๊ธฐ๊ฐ ์ด๋ ต๊ฒ ๋์๋ค. `String` ์ `extension`์ผ๋ก ๋ฐ๋ก ๋ง๋ค์ด์ Attributed String์ ๋ฐ์์ค๋ ํํ๋ก ๊ฐ์ ํ๊ณ  ์ถ๋ค. 

<br>

### ๐ฆ ์ค์
1. `ํด๊ฒฐํจ` ํ๋กํ ์ฝ์ ์ด์ฉํ์ฌ ๊ฐ์ ์ญ์ ๋ฌ ํ  ๋: ์๊พธ ํด๋น ํ๋กํ ์ฝ ํ์์ VC๋ฅผ ๋ฃ์ ์ ์๋ค๋ ์๋ฌ๊ฐ ๋ด๋๋ฐ, ์๊ณ  ๋ณด๋ `var delegate = protocolName?` ์ผ๋ก ํด๋ ๊ฒ... ๐คฆ ๋ชป ์ฐพ์์ ๊ฒ์์ผ๋ก 3์๊ฐ ํค๋งธ๋ค. 
2. `ํด๊ฒฐํจ` ํ๋กํ ์ฝ ์ ์ํ  ๋ `AnyObject`๋ฅผ ์ฑํํ์ง๋ง, ์ฝํ ์ฐธ์กฐ๋ก ์ ์ธํ์ง ์์ ๋ถ๋ถ -> ์ฝํ ์ฐธ์กฐ์ ๋ํด ์ฝํ ์ดํด๊ฐ ์์๋ค! ์์์ผ๋ก ๋ฐฐ์์ ๋ฐ๋ก ์ ์ฉํ๋ค! 
3. `ํด๊ฒฐํจ` ์ฝ๋๋ก ๊ตฌํํ๊ณ  ๋๋ ๊ฑธ ํ์ธํ๋ ๊ฒ ๊ฐ์๋ฐ, ์์  ๋ชจ๋์์ ๋ฐ๋ฒํผ ์์ดํ๊ณผ ํค๋ณด๋๊ฐ ์ ๋๋ก ์ ์์ด์ง๋ ๊ฑธ ํ์ธํจ...๐ฅฒ -> ์กธ๋ ค์ ์ฝ๋๋ฅผ ์ข ๋ ๋ ธ๋ ๊ฒ ๊ฐ๋ค. ์ ์ถ ํ์ ์์ ํจ (์ด์ #40)

<br>

### ๐คทโโ๏ธ ์ข ๋ ๊ณต๋ถํ๊ฑฐ๋ ์ฐพ์๋ณผ ๋ถ๋ถ
1. `Realm Object`๋ฅผ ๋ค๋ฅธ ํ๋ฉด์ผ๋ก ๋ณด๋ด์, ๊ทธ๊ณณ์ ์ ์ธํ `repository`๋ฅผ ์ด์ฉํ๋ฉด ๋์ผํ write thread๊ฐ ์๋๋ผ์ ์๊ธฐ๋ ์๋ฌ. ์ฐ๋ ๋์ ๋ํ ๋ถ๋ถ์ด ์์ง ์ด๋ ต๋ค.
2. `Done` - `searchController`๋ฅผ ์ ์ฉํ ์ํ์์ ์์ฑํ๊ธฐ๋ฅผ ํด๋ฆญํ๋ฉด, ์๋ฎฌ๋ ์ดํฐ์์๋ ๋ค๋น๊ฒ์ด์ ๋ฐ๊ฐ ์์ ์์ดํ ํฌ๊ธฐ์ ๋ง์ถฐ ์๋์ผ๋ก ์ค์ด๋ค์ง๋ง ์ ๋๋ฐ์ด์ค์์๋ ๋ค๋น๊ฒ์ด์ ๋ฐ๊ฐ ์๋์ผ๋ก ์ ์ค์ด๋ค๊น? -> `prefersLargeTitle`์ `false`๋ก ๋ฐ๊ฟ์ฃผ๋ฉด ๋๋ค. thx to @GoForWalk 
3. `inset grouped`์์ ์น์ ํค๋๊ฐ ์์ด ์์ํ๋ ์์น์ ๊ฐ์ผ๋ฉด ์ข๊ฒ ๋๋ฐ ์ด๋ป๊ฒ ์ฎ๊ธธ์ง. 
4. ~์ค์์ดํ ์ก์ ์์ญ์ด ๋๋ฌด ํฐ ๊ฒ ๊ฐ์๋ฐ ๊ณต๊ฐ์ ์ค์ผ ์ ์์๊น?~ <- ์ ๋์ด๊ฐ ์์์ ๊ทธ๋ ๊ฒ ๋ณด์ด๋ ๊ฒ. ์ค์์ดํ์ก์์์ ๊ฐ๋ก๋ก ์ฐจ์งํ๋ ์์ญ ์์ฒด๋ ๋๊ฐ๋ค! 
5. `isEditing` ์ ๋ํด ์ข ๋ ์ฐพ์๋ณด๊ธฐ! 
