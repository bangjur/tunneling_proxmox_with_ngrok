# tunneling_proxmox_with_ngrok

disini saya melakukan eksperimen tentang bagaimana saya bisa mengakses proxmox yang ada di laptop bekas saya via internet (di luar network rumah). requirement nya tentu saja:
1. laptop dengan proxmox terinstall dan bisa diakses via local network (sangat disarankan laptop terhubung via kabel ethernet, bukan wireless)
2. ngrok dan authToken-nya yang didapat setelah daftar di website ngrok
3. nginx yang terinstall di proxmox dan bisa diakses (http://localhost --> "Welcome to Nginx")
4. tentu saja internet yang lancar 🤣

okey berikut langkah-langkah nya:
1. pertama, perlu dipahami bahwa proxmox berjalan di https (bukan http) menggunakan self-signed certificate. kalau anda perhatikan, https nya tercoret (strikethrough).
2. karena berjalan di https, maka kita perlu file .crt dan file .key
3. untuk memenuhi poin (3), jalankan script _generate_ssl.sh_ yang ada di repo ini dengan **sudo bash generate_ssl.sh** atau kalau anda sudah login sebagai root di proxmox **tidak perlu sudo**
4. kemudian, jalankan file _setup_nginx_proxmox.sh_ dengan cara yg sama.
5. untuk penggunaan ngrok, jalankan **ngrok config add-authtoken $YOUR_AUTHTOKEN** dengan authToken yang kamu dapat di website ngrok.
6. terakhir, jalankan **ngrok http 443**, copy link nya dan akses di browser.
7. HWALAAA HUMBAAA 🔥🔥
