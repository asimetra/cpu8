# cpu8 — 8-bit CPU

Register'dan başlayıp çalışan bir bilgisayar sistemine kadar dokuz lab boyunca
büyüyen 8-bit işlemci. Simülasyon Icarus Verilog, dalga formları GTKWave.

## Kurulum

```bash
sudo dnf install iverilog gtkwave
code --install-extension mshr-h.veriloghdl   # isteğe bağlı: renklendirme + kaydederken lint
```

## Klasörler

| Klasör   | İçerik |
|----------|--------|
| `rtl/`   | Donanım modülleri. **Dosya adı = modül adı** (`register8.v` → `module register8`); testbench'ler modülleri bu adla bulur. |
| `tb/`    | Testbench'ler, `tb_<modül>.v` adıyla. Ortak yardımcılar `test_utils.vh` içinde. |
| `waves/` | GTKWave'de kaydedilen sinyal düzenleri (`tb_<modül>.gtkw`); `make wave` varsa bunu açar. |
| `build/` | Derleme çıktıları, `.vcd` ve log dosyaları (git'e girmez). |

Modüller lab'lar boyunca tekrar kullanılır: Lab 3'teki datapath, Lab 1'deki
`register8`'i ve Lab 2'deki ALU'yu doğrudan örnekler; kopya yoktur.

## Komutlar

```bash
make                     # tb/ altındaki tüm testbench'leri çalıştır, PASS/FAIL özeti
make sim TB=register8    # tek testbench, $display çıktısıyla
make wave TB=register8   # çalıştır ve GTKWave'de aç
make lint                # rtl/ altındaki her şeyi uyarılarla derle
make clean
```

## Testbench iskeleti

```verilog
`timescale 1ns/1ps
`include "test_utils.vh"

module tb_register8;
    `TB_INIT(tb_register8)          // hata sayacı + build/tb_register8.vcd

    // sinyaller, DUT, clock ...

    initial begin
        // uyarılar ...
        `CHECK(q, 8'hA5, "load")    // !== ile karşılaştırır: x/z de hata sayılır
        `TB_DONE                    // hata yoksa PASS, varsa $fatal → make FAIL der
    end
endmodule
```

## Lab'lar

Her lab bitince o anki hali etiketlenir: `git tag lab1`.
`git checkout lab1` ile teslim edilen haline dönülebilir.

| Lab | Konu |
|-----|------|
| 1 | Register ve mikroişlemlerle veri transferi (8-bit register, ortak BUS) |
| 2 | ALU: aritmetik/mantıksal işlemler |
| 3 | Register + ALU + BUS → datapath |
| 4 | Opcode çözme |
| 5 | Komutların zaman sıralı mikroişlemlerle yürütülmesi |
| 6 | Instruction memory'den komut getirme |
| 7 | Datapath entegrasyon doğrulaması |
| 8 | Control Unit + Datapath → CPU çekirdeği |
| 9 | Tüm parçalar → çalışan bilgisayar sistemi |
