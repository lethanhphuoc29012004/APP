using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MILANO_64131856.Models;

namespace MILANO_64131856.Controllers
{
    public class LoaiSanPham_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: LoaiSanPham_64131856
        public ActionResult Index()
        {
            return View(db.LoaiSanPhams.ToList());
        }

        // GET: LoaiSanPham_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiSanPham loaiSanPham = db.LoaiSanPhams.Find(id);
            if (loaiSanPham == null)
            {
                return HttpNotFound();
            }
            return View(loaiSanPham);
        }

        // GET: LoaiSanPham_64131856/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: LoaiSanPham_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaLoai,TenLoai")] LoaiSanPham loaiSanPham)
        {
            if (ModelState.IsValid)
            {
                db.LoaiSanPhams.Add(loaiSanPham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(loaiSanPham);
        }

        // GET: LoaiSanPham_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiSanPham loaiSanPham = db.LoaiSanPhams.Find(id);
            if (loaiSanPham == null)
            {
                return HttpNotFound();
            }
            return View(loaiSanPham);
        }

        // POST: LoaiSanPham_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaLoai,TenLoai")] LoaiSanPham loaiSanPham)
        {
            if (ModelState.IsValid)
            {
                db.Entry(loaiSanPham).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(loaiSanPham);
        }

        // GET: LoaiSanPham_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiSanPham loaiSanPham = db.LoaiSanPhams.Find(id);
            if (loaiSanPham == null)
            {
                return HttpNotFound();
            }
            return View(loaiSanPham);
        }

        // POST: LoaiSanPham_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            LoaiSanPham loaiSanPham = db.LoaiSanPhams.Find(id);
            db.LoaiSanPhams.Remove(loaiSanPham);
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
        //tim kiem loai sp
        public ActionResult TimKiemLoaiSanPham_64131856(string maLoai = "", string tenLoai = "")
        {
            ViewBag.maLoai = maLoai;
            ViewBag.tenLoai = tenLoai;

            // Gọi stored procedure LoaiSanPham_TimKiem với các tham số tìm kiếm
            var loaiSanPhams = db.LoaiSanPhams.SqlQuery("EXEC LoaiSanPham_TimKiem '" + maLoai + "', '" + tenLoai + "'");

            if (!loaiSanPhams.Any())
                ViewBag.TB = "Không có thông tin tìm kiếm.";

            return View(loaiSanPhams.ToList());
        }

    }
}
