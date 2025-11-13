class rssresource{
  String id, name;
  String startImageRegrex, endImageRegrex;
  String startDescriptionRegrex, endDescriptionRegrex;
  Map<String, String>resourceHeaders;

  rssresource({required this.id,
    required this.name,
    required  this.startImageRegrex,
    required this.endImageRegrex,
    required this.startDescriptionRegrex,
    required this.endDescriptionRegrex,
    required this.resourceHeaders,}
      );


}
List<rssresource> rssResource = [
  rssresource(
      id: "vnexpress",
      name: "VNExpress",
      startImageRegrex: 'img src="',
      endImageRegrex: '"',
      startDescriptionRegrex: "</a></br>",
      endDescriptionRegrex: "",
      resourceHeaders: {
        "Trang chủ": "https://vnexpress.net/rss/tin-moi-nhat.rss",
        "Thời sự": "https://vnexpress.net/rss/thoi-su.rss",
        "Sức khoẻ": "https://vnexpress.net/rss/suc-khoe.rss",
        "Thế giới": "https://vnexpress.net/rss/the-gioi.rss",
        "Đời sống": "https://vnexpress.net/rss/gia-dinh.rss",
        "Du lịch": "https://vnexpress.net/rss/du-lich.rss",
        "Khoa học": "https://vnexpress.net/rss/khoa-hoc.rss",
        "Kinh doanh": "https://vnexpress.net/rss/kinh-doanh.rss",
        // "Starup": "https://vnexpress.net/rss/startup.rss",
        "Công nghệ": "https://vnexpress.net/rss/cong-nghe.rss",
        "Giải trí": "https://vnexpress.net/rss/giai-tri.rss",
        "Xe": "https://vnexpress.net/rss/oto-xe-may.rss",
        "Thể thao": "https://vnexpress.net/rss/the-thao.rss",
        "Ý kiến": "https://vnexpress.net/rss/y-kien.rss",
        "Pháp luật": "https://vnexpress.net/rss/phap-luat.rss",
        "Tâm sự": "https://vnexpress.net/rss/tam-su.rss",
        "Giáo dục": "https://vnexpress.net/rss/giao-duc.rss",
        "Cười": "https://vnexpress.net/rss/cuoi.rss",
      }),
  rssresource(id: "tuoitre", name: "TuoiTre",
      startImageRegrex: 'img src="',
      endImageRegrex: '" /',
      startDescriptionRegrex: "</a>",
      endDescriptionRegrex: "",
      resourceHeaders: {
        "Nhịp sống trẻ": "https://tuoitre.vn/rss/nhip-song-tre.rss",
        "Thư giãn": "https://tuoitre.vn/rss/thu-gian.rss",
        "Giả thật": "https://tuoitre.vn/rss/gia-that.rss",
        "Văn hoá": "https://tuoitre.vn/rss/van-hoa.rss",
      }),
];