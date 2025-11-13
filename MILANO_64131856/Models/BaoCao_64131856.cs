using System;
using System.Collections.Generic;

namespace MILANO_64131856.Models
{
    public class BaoCao_64131856
    {
        public List<Product_64131856> Products { get; set; }
        public int TongSoLuongTon { get; set; }
        public decimal TongTienTon { get; set; }
    }

    public class Product_64131856
    {
        public string TenSanPham { get; set; }
        public int SoLuongTon { get; set; }
        public decimal TongTienTon { get; set; }
    }
}
