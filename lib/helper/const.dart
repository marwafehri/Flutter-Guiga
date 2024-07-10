import 'package:woocommerce_app/helper/woocommerce_api.dart';
/*
class Const {
  static WooCommerceAPI wc_api = new WooCommerceAPI(
      "your_host_name", "your_consumer_key", "your_secret_key");
}*/
class Const {
  static WooCommerceAPI wc_api = new WooCommerceAPI(
      "https://www.drg.deveoo.net/wp-json/wc/v3/",
      "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4",
      "cs_d3670298854d8029b649762a4fa274311041080a");
}

class Constbooking {
  static WooCommerceAPI wc_apibooking = new WooCommerceAPI(
      "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/",
      "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4",
      "cs_d3670298854d8029b649762a4fa274311041080a");
}

class Constwordpress {
  static WooCommerceAPI wc_apiwordpress = new WooCommerceAPI(
      "https://www.drg.deveoo.net/wp-json/wp/v2/",
      "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4",
      "cs_d3670298854d8029b649762a4fa274311041080a");
}
class Constword {
  static WooCommerceAPI wc_apiword = new WooCommerceAPI(
      "https://www.drg.deveoo.net/wp-json/api/v1/",
      "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4",
      "cs_d3670298854d8029b649762a4fa274311041080a");
}

class ConstwordForm {
  static WooCommerceAPI wc_apiwordform = new WooCommerceAPI(
      "https://www.drg.deveoo.net/wp-json/contact-form-7/v1/",
      "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4",
      "cs_d3670298854d8029b649762a4fa274311041080a");
}

