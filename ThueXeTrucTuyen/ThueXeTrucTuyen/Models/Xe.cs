using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ThueXeTrucTuyen.Models
{
    [MetadataType(typeof(XeMetadata))]
    public partial class Xe
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Xe()
        {
            this.DanhGias = new HashSet<DanhGia>();
            this.DonThueXes = new HashSet<DonThueXe>();
            this.KhachHangs = new HashSet<KhachHang>();
        }

        public int id { get; set; }

        public string ten_xe { get; set; }

        public string bien_so { get; set; }

        public int id_hang_xe { get; set; }

        public int nam_san_xuat { get; set; }

        public string loai_xe { get; set; }

        public decimal gia_thue_ngay { get; set; }

        public string hinh_xe { get; set; }

        public string trang_thai { get; set; }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DanhGia> DanhGias { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DonThueXe> DonThueXes { get; set; }

        public virtual HangXe HangXe { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<KhachHang> KhachHangs { get; set; }
    }

    public class XeMetadata
    {
        [Required(ErrorMessage = "Ten xe khong duoc de trong")]
        [StringLength(100, ErrorMessage = "Ten xe khong duoc vuot qua 100 ky tu")]
        public string ten_xe { get; set; }

        [Required(ErrorMessage = "Bien so khong duoc de trong")]
        [StringLength(11, ErrorMessage = "Bien so khong duoc vuot qua 11 ky tu")]
        
        public string bien_so { get; set; }

        [Required(ErrorMessage = "Ban phai chon hang xe")]
        public int id_hang_xe { get; set; }

        [Required(ErrorMessage = "Nam san xuat khong duoc de trong")]
        [Range(1900, 2100, ErrorMessage = "Nam san xuat phai tu 1900 den 2100")]
        public int nam_san_xuat { get; set; }

        [Required(ErrorMessage = "Loai xe khong duoc de trong")]
        [StringLength(50, ErrorMessage = "Loai xe khong duoc vuot qua 50 ky tu")]
        public string loai_xe { get; set; }

        [Required(ErrorMessage = "Gia thue phai la so duong")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Gia thue phai la so duong")]
        public decimal gia_thue_ngay { get; set; }

        [StringLength(200, ErrorMessage = "Ten file hinh xe khong duoc vuot qua 200 ky tu")]

       
        public string hinh_xe { get; set; }

        [Required(ErrorMessage = "Trang thai khong duoc de trong(Da Thue/Chua Thue)")]
        [StringLength(50, ErrorMessage = "Trang thai khong duoc vuot qua 50 ky tu")]
        public string trang_thai { get; set; }
    }
}
