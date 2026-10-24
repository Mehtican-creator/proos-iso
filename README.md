# Pro OS ISO projesi

Debian 13 + Xfce + Pro OS markası + Calamares kurulum sihirbazı. ISO'yu GitHub kendi sunucusunda derler.

## Derleme (GitHub üzerinde)
1. GitHub'da yeni bir depo aç (ör. `proos-iso`).
2. Bu klasörün **içindekileri** (`.github`, `config`, `build.sh`, `README.md`) depoya yükle.
   `.github` klasörü görünmüyorsa Windows'ta "gizli öğeleri göster"i aç.
3. Depoda **Actions** sekmesi → **Pro OS ISO derle** → **Run workflow**.
4. 40-90 dakika sonra bittiğinde çalışmanın sayfasında **Artifacts → ProOS-iso** indirilir (zip içinde `ProOS.iso`).

## Kullanım
- VirtualBox: yeni makine, ISO'yu bağla (en az 4 GB RAM, 25 GB disk), aç. Masaüstündeki **Pro OS'u Kur** simgesine çift tıkla.
- Gerçek bilgisayar: ISO'yu Rufus ile USB'ye yaz.
