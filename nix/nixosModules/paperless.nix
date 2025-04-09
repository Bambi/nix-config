_: {
  services.paperless = {
    enable = true;
    address = "192.168.0.254";
    port = 29000;
    mediaDir = "/data/media/paperless";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "fra+eng";
      # PAPERLESS_ADMIN_USER = "admin";
      # PAPERLESS_ADMIN_PASSWORD = "";
    };
  };
  # systemd.services.paperless-scheduler.after = ["var-lib-paperless.mount"];
  # systemd.services.paperless-consumer.after = ["var-lib-paperless.mount"];
  # systemd.services.paperless-web.after = ["var-lib-paperless.mount"];
  # systemd.services.paperless-task-queue.after = ["var-lib-paperless.mount"];
}
