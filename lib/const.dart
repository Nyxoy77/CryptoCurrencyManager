const String API_KEY_CRYPTO_IO =
    "b48e3dfe08761e8ec24c9763c47a1d62c3d77d085281d1621d48ffb9e33d";

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
