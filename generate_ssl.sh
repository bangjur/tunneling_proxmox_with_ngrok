#!/bin/bash

# Nama file sertifikat & key
CERT_NAME="server"

# Direktori tujuan
CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"

echo "🔹 Generating private key (without passphrase)..."
openssl genpkey -algorithm RSA -out "${CERT_NAME}.key"

echo "🔹 Generating CSR (Certificate Signing Request)..."
openssl req -new -key "${CERT_NAME}.key" -out "${CERT_NAME}.csr" \
  -subj "/C=ID/ST=Jawa Barat/L=Bandung/O=MyCompany/OU=IT/CN=localhost"

echo "🔹 Generating self-signed certificate (valid for 1 year)..."
openssl x509 -req -days 365 -in "${CERT_NAME}.csr" -signkey "${CERT_NAME}.key" -out "${CERT_NAME}.crt"

# Memastikan direktori tujuan ada
echo "🔹 Moving certificate and key to /etc/ssl/"
sudo mkdir -p "$CERT_DIR" "$KEY_DIR"
sudo mv "${CERT_NAME}.crt" "$CERT_DIR/"
sudo mv "${CERT_NAME}.csr" "$CERT_DIR/"
sudo mv "${CERT_NAME}.key" "$KEY_DIR/"

# Mengatur permission
echo "🔹 Setting permissions..."
sudo chmod 600 "$KEY_DIR/${CERT_NAME}.key"
sudo chmod 644 "$CERT_DIR/${CERT_NAME}.crt"
sudo chmod 644 "$CERT_DIR/${CERT_NAME}.csr"

# Verifikasi
echo "🔹 Verifying certificate..."
openssl x509 -in "$CERT_DIR/${CERT_NAME}.crt" -text -noout

echo "✅ SSL Certificate and Private Key generated successfully!"
echo "   - Private Key: $KEY_DIR/${CERT_NAME}.key"
echo "   - Certificate: $CERT_DIR/${CERT_NAME}.crt"
echo "   - CSR: $CERT_DIR/${CERT_NAME}.csr"
