using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MILANO_64131856.Models;

namespace MILANO_64131856.Controllers
{
    public class SanPhamStaff_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: SanPhamStaff_64131856
        public ActionResult Index()
        {
            var sanPhams = db.SanPhams.Include(s => s.LoaiSanPham);
            return View(sanPhams.ToList());
        }
        //tomkiemsanpham
        public ActionResult TimKiemSanPhamStaff_64131856(string maSanPham = "", string tenSanPham = "")
        {
            ViewBag.maSanPham = maSanPham;
            ViewBag.tenSanPham = tenSanPham;


            // Gọi stored procedure SanPham_TimKiem với các tham số tìm kiếm
            var sanPhams = db.SanPhams.SqlQuery("SanPham_TimKiem'" + maSanPham + "', '" + tenSanPham + "'");

            if (!sanPhams.Any())
                ViewBag.TB = "Không có thông tin tìm kiếm.";

            return View(sanPhams.ToList());
        }
        // GET: SanPhamStaff_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // GET: SanPhamStaff_64131856/Create
        public ActionResult Create()
        {
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai");
            return View();
        }

        // POST: SanPhamStaff_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaSanPham,TenSanPham,MaLoai,GiaBan,SoLuongTon,AnhSanPham")] SanPham sanPham)
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
                sanPham.AnhSanPham = postedFileName;
                db.SanPhams.Add(sanPham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // GET: SanPhamStaff_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // POST: SanPhamStaff_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaSanPham,TenSanPham,MaLoai,GiaBan,SoLuongTon,AnhSanPham")] SanPham sanPham)
        {
            if (ModelState.IsValid)
            {
                db.Entry(sanPham).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // GET: SanPhamStaff_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // POST: SanPhamStaff_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            SanPham sanPham = db.SanPhams.Find(id);
            db.SanPhams.Remove(sanPham);
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
    }
}
