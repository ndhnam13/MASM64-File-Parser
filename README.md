
# Parse PE File

## Cách parse các section

> **PE32 và PE32+ có độ lớn của Optional Header khác nhau => Từ Optional Header trở đi phải parse riêng**

Dùng SetFilePointer để đặt con trỏ file đến đầu offset, ReadFile để lấy nội dung

Tham khảo về offset, size của các section của cả PE32 và PE32+

- https://learn.microsoft.com/en-us/windows/win32/debug/pe-format

## Cách parse Import Directory

Sau khi parse xong Optional và Section header ta sẽ có những thông tin sau

- RVA và Size của Import Directory

- Raw Address, Virtual address và Virtual size của các Sections

Tìm Section mà RVA của Import Directory thuộc vào:

```python
sectionVA < importRVA < (sectionVA + sectionVSize) 
```

- Nếu điều kiện thoả mãn => Import Directory nằm trong đây

Khi biết được Import Directory nằm trong section nào rồi ta sẽ lấy Raw Address của nó:

```python
firstDllOffset = Base + <section>.RawAddr + (importDirectory.RVA − <section>.VA)
```

- Đây sẽ là offset của DLL import thứ nhất, mỗi import chiếm 20 byte. Dựa vào Import Size ta sẽ biết được có khoảng bao nhiêu import qua `importNumber = (importSize / 20) - 1` 
- `firstDllOffset` là 1 struct `_IMAGE_IMPORT_DESCRIPTOR`

```c++
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
	union {
		DWORD	Characteristics; /* 0 for terminating null import descriptor  */
		DWORD	OriginalFirstThunk;	/* RVA to original unbound IAT */
	} DUMMYUNIONNAME;
	DWORD	TimeDateStamp;	/* 0 if not bound,
				 * -1 if bound, and real date\time stamp
				 *    in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT
				 * (new BIND)
				 * otherwise date/time stamp of DLL bound to
				 * (Old BIND)
				 */
	DWORD	ForwarderChain;	/* -1 if no forwarders */
	DWORD	Name;
	/* RVA to IAT (if bound this IAT has actual addresses) */
	DWORD	FirstThunk;
} IMAGE_IMPORT_DESCRIPTOR,*PIMAGE_IMPORT_DESCRIPTOR;
```

Trong 1 các file khi parse trên disk sẽ thấy `OriginalFirstThunk` và `FirstThunk` có giá trị giống nhau và đều là RVA trỏ đến `IMAGE_THUNK_DATA`:

- OFT: Chứa thông tin cố định (địa chỉ trỏ đến tên hàm hoặc ordinal) không bao giờ thay đổi sau khi biên dịch. Khi file PE được nạp, loader dựa vào đây để biết hàm nào cần tìm
- FT: Chứa địa chỉ thực tế của các hàm import sau khi chương trình được nạp vào bộ nhớ. Lúc đầu, nó giống OFT. Tại thời điểm chạy (runtime), loader ghi đè các địa chỉ thực tế vào đây để chương trình gọi hàm

Byte 12->15 từ offset vừa lấy được sẽ cho ta nameRVA của DLL đó, tiếp tục áp dụng công thức trên

```python
DllNameOffset = Base + <section>.RawAddr + (nameRVA − <section>.VA)
```

- Ta sẽ có được offset tới tên của DLL

Để lấy được tên của các hàm của DLL mà chương trình import, ta sẽ dựa vào byte 0->3 của `firstDllOffset` có tên là `OriginalFirstThunk`

```py
OriginalFirstThunkOffset = Base + <section>.RawAddr + (OftVA − <section>.VA)
```

- Từ đây ta sẽ có offset tới `OriginalFirstThunk`. Tại đó ta sẽ lấy 4 byte đầu là RVA của `Thunk` sẽ trỏ đến `IMAGE_IMPORT_BY_NAME`, áp dụng công thúc để đổi từ RVA thành Offset

```c++
typedef struct _IMAGE_IMPORT_BY_NAME {
	WORD	Hint;
	char	Name[1];
} IMAGE_IMPORT_BY_NAME,*PIMAGE_IMPORT_BY_NAME;
```

```
firstFunctionNameOffset = [Base + <section>.RawAddr + (firstFunctionNameRVA − <section>.VA)] + 2
```

> Cộng thêm 2 byte bởi 2 byte đầu là Hint

- Ta có được tên của function đầu tiên

Để tiếp tục lấy tên của các function tiếp theo ta phải tiếp tục lấy các RVA của firstThunk tiếp theo. Format của các thunk sẽ như thế này: 

```
[4 byte RVA] [4 byte 0] = 8 byte

Nếu DLL import nhiều hơn 1 function thì sau 8 byte từ firstThunkOffset sẽ là RVA của function tiếp theo
```

- Để parse được hết tất cả các function import từ DLL ta sẽ cần phải parse 8 byte một cho đến khi gặp 8 byte 0 liên tiếp thì dừng

## Cách parse Export Directory

Tương tự, phần RVA của Export Directory cũng sẽ được tính toán để xem thuộc vào section nào, rồi đổi ra rawOffset để truy cập. Trong Export Dir sẽ có các phần sau:

- +0x0C = NameRva: RVA đến tên của DLL/EXE
- +0x14 = NumberOfFunctions: Tổng số hàm được export bởi DLL/EXE
- +0x18 = NumberOfNames: Tổng số lượng symbol được export bằng name
- +0x1C = AddressOfFunctions: RVA đến các RVA địa chỉ của hàm
- +0x20 = AddressOfNames: RVA đến các RVA tên của hàm
- +0x24 = AddressOfNameOrdinals: RVA đến số ordinal của hàm

Để parse ta sẽ cần lấy `NumberOfFunctions` làm counter, lưu lại rawOffset (Sau khi đổi từ RVA) của `AddressOfFunctions, AddressOfNames, AddressOfNameOrdinals`

Đối với `AddressOfFunctions` và `AddressOfNames`, tại rawOffset của chúng sẽ tiếp tục là các RVA (4 byte) đến địa chỉ/tên 1 hàm. Địa chỉ của hàm đó sẽ có độ lớn 8 byte

- Lấy ordinal của hàm đó (thông qua counter), dùng ordinal của hàm đó truy cập tên và địa chỉ hàm 

# Parse ELF File

REFs

- https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779

## Struct

```c
//Elf Header
typedef struct
{
  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */
  Elf64_Half	e_type;			/* Object file type */
  Elf64_Half	e_machine;		/* Architecture */
  Elf64_Word	e_version;		/* Object file version */
  Elf64_Addr	e_entry;		/* Entry point virtual address */
  Elf64_Off	e_phoff;		/* Program header table file offset */
  Elf64_Off	e_shoff;		/* Section header table file offset */
  Elf64_Word	e_flags;		/* Processor-specific flags */
  Elf64_Half	e_ehsize;		/* ELF header size in bytes */
  Elf64_Half	e_phentsize;		/* Program header table entry size */
  Elf64_Half	e_phnum;		/* Program header table entry count */
  Elf64_Half	e_shentsize;		/* Section header table entry size */
  Elf64_Half	e_shnum;		/* Section header table entry count */
  Elf64_Half	e_shstrndx;		/* Section header string table index */
} Elf64_Ehdr;

//Program Header
typedef struct
{
  Elf64_Word	p_type;			/* Segment type */
  Elf64_Word	p_flags;		/* Segment flags */
  Elf64_Off	p_offset;		/* Segment file offset */
  Elf64_Addr	p_vaddr;		/* Segment virtual address */
  Elf64_Addr	p_paddr;		/* Segment physical address */
  Elf64_Xword	p_filesz;		/* Segment size in file */
  Elf64_Xword	p_memsz;		/* Segment size in memory */
  Elf64_Xword	p_align;		/* Segment alignment */
} Elf64_Phdr;

// Section Header
typedef struct
{
  Elf64_Word	sh_name;		/* Section name (string tbl index) */
  Elf64_Word	sh_type;		/* Section type */
  Elf64_Xword	sh_flags;		/* Section flags */
  Elf64_Addr	sh_addr;		/* Section virtual addr at execution */
  Elf64_Off	sh_offset;		/* Section file offset */
  Elf64_Xword	sh_size;		/* Section size in bytes */
  Elf64_Word	sh_link;		/* Link to another section */
  Elf64_Word	sh_info;		/* Additional section information */
  Elf64_Xword	sh_addralign;		/* Section alignment */
  Elf64_Xword	sh_entsize;		/* Entry size if section holds table */
} Elf64_Shdr;

//Symbol
typedef struct
{
  Elf64_Word	st_name;		/* Symbol name (string tbl index) */
  unsigned char	st_info;		/* Symbol type and binding */
  unsigned char st_other;		/* Symbol visibility */
  Elf64_Section	st_shndx;		/* Section index */
  Elf64_Addr	st_value;		/* Symbol value */
  Elf64_Xword	st_size;		/* Symbol size */
} Elf64_Sym;

```
