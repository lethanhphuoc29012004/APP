using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ThueXeTrucTuyen.Models;

namespace ThueXeTrucTuyen.Controllers
{
    public class XesController : Controller
    {
        private ThueXeTrucTuyenEntities db = new ThueXeTrucTuyenEntities();
        

        // GET: Xes
        public ActionResult Index()
        {
            var xes = db.Xes.Include(x => x.HangXe);
            return View(xes.ToList());
        }

        // GET: Xes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Xe xe = db.Xes.Find(id);
            if (xe == null)
            {
                return HttpNotFound();
            }
            return View(xe);
        }

        // GET: Xes/Create
        public ActionResult Create()
        {
            var hangXeList = db.HangXes.ToList();
            ViewBag.id_hang_xe = new SelectList(db.HangXes, "id", "ten_hang");
            ViewBag.HangXeList = new SelectList(hangXeList, "id", "ten_hang");
            ViewBag.HangXeData = hangXeList.Select(h => new { h.id, h.ten_hang, h.quoc_gia }).ToList();
            return View();
        }

        // POST: Xes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,ten_xe,bien_so,id_hang_xe,nam_san_xuat,loai_xe,gia_thue_ngay,hinh_xe,trang_thai")] Xe xe)
        {
            //System.Web.HttpPostedFileBase Avatar;
            var img = Request.Files["Avatar"];
            //Lấy thông tin từ input type=file có tên Avatar
            string postedFileName = System.IO.Path.GetFileName(img.FileName);
            //Lưu hình đại diện về Server
            var path = Server.MapPath("/Images/" + postedFileName);
            img.SaveAs(path);
            if (ModelState.IsValid)
            {
                xe.hinh_xe = postedFileName;
                db.Xes.Add(xe);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.id_hang_xe = new SelectList(db.HangXes, "id", "ten_hang", xe.id_hang_xe);
            return View(xe);
        }

        // GET: Xes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Xe xe = db.Xes.Find(id);
            if (xe == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_hang_xe = new SelectList(db.HangXes, "id", "ten_hang", xe.id_hang_xe);
            return View(xe);
        }

        // POST: Xes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,ten_xe,bien_so,id_hang_xe,nam_san_xuat,loai_xe,gia_thue_ngay,hinh_xe,trang_thai")] Xe xe)
        {
            if (ModelState.IsValid)
            {
                db.Entry(xe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_hang_xe = new SelectList(db.HangXes, "id", "ten_hang", xe.id_hang_xe);
            return View(xe);
        }

        // GET: Xes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Xe xe = db.Xes.Find(id);
            if (xe == null)
            {
                return HttpNotFound();
            }
            return View(xe);
        }

        // POST: Xes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Xe xe = db.Xes.Find(id);
            db.Xes.Remove(xe);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
        public ActionResult TimKiemXe_64131856(string maXe, string tenXe, string bienSo, string namSX, string loaiXe, string giaThue, string hangXe)
        {
            var ds = db.Xes.Include(x => x.HangXe).AsQueryable();

            if (!string.IsNullOrEmpty(maXe))
                ds = ds.Where(x => x.id.ToString().Contains(maXe));

            if (!string.IsNullOrEmpty(tenXe))
                ds = ds.Where(x => x.ten_xe.Contains(tenXe));

            if (!string.IsNullOrEmpty(bienSo))
                ds = ds.Where(x => x.bien_so.Contains(bienSo));

            if (!string.IsNullOrEmpty(namSX) && int.TryParse(namSX, out int nam))
                ds = ds.Where(x => x.nam_san_xuat == nam);

            if (!string.IsNullOrEmpty(loaiXe))
                ds = ds.Where(x => x.loai_xe.Contains(loaiXe));

            if (!string.IsNullOrEmpty(giaThue) && decimal.TryParse(giaThue, out decimal gia))
                ds = ds.Where(x => x.gia_thue_ngay <= gia);

            // ✅ THÊM ĐIỀU KIỆN LỌC THEO TÊN HÃNG XE
            if (!string.IsNullOrEmpty(hangXe))
                ds = ds.Where(x => x.HangXe.ten_hang.Contains(hangXe));

            // Truyền lại các giá trị tìm kiếm để hiển thị lại trong form
            ViewBag.MaXe = maXe;
            ViewBag.TenXe = tenXe;
            ViewBag.BienSo = bienSo;
            ViewBag.NamSX = namSX;
            ViewBag.LoaiXe = loaiXe;
            ViewBag.GiaThue = giaThue;
            ViewBag.HangXe = hangXe;

            if (!ds.Any())
                ViewBag.TB = "Không tìm thấy xe phù hợp.";

            return View("TimKiemXe_64131856", ds.ToList());
        }



    }
}
