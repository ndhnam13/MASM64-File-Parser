## Cách parse tên DLL, tên API import 

Sau khi parse xong Optional và Section header ta sẽ có những thông tin sau

- RVA và Size của Import Directory

- Raw offset, size của các Sections; Virtual address và size của các Sections

Tìm Section mà RVA của Import Directory thuộc vào:

```python
importRVA > sectionVA and importRVA < (sectionVA + sectionVA_Size) 
```

- Điều kiện thoả mãn => Import Directory nằm trong đây

Khi biết được Import Directory nằm trong section nào rồi ta sẽ lấy raw offset của nó:

```python
firstDllOffset = imageBase + <section>.RawOffset + (importDirectory.RVA − <section>.VA)
```

- Đây sẽ là offset của DLL import thứ nhất, mỗi import chiếm 20 byte. Dựa vào Import Size ta sẽ biết được có khoảng bao nhiêu import qua `importNumber = importSize / 20` (Có thể ít hơn bởi vì thường kết thúc bằng 4 byte 0)

Byte 13->16 từ offset vừa lấy được sẽ cho ta name RVA của DLL đó, tiếp tục áp dụng công thức trên

```python
DllNameOffset = imageBase + <section>.RawOffset + (nameRVA − <section>.VA)
```

- Ta sẽ có được tên của DLL

Để lấy được tên của các API, ta sẽ dựa vào byte 1->4 của `firstDllOffset` có tên là `OriginalFirstThunk`

```py
firstThunkOffset = imageBase + <section>.RawOffset + (OftVA − <section>.VA)
firstFunctionOffset = [imageBase + <section>.RawOffset + (firstThunkOffset+4 − <section>.VA)] + 2
```

- Ta có được tên của function 

REFs

- https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/pe-file-header-parser-in-c++