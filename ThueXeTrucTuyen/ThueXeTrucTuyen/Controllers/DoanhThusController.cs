using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ThueXeTrucTuyen.Models;

namespace ThueXeTrucTuyen.Controllers
{
    public class DoanhThusController : Controller
    {
        private ThueXeTrucTuyenEntities db = new ThueXeTrucTuyenEntities();

        // GET: DoanhThus
        public ActionResult BaoCaoDoanhThu(DateTime? fromDate, DateTime? toDate)
        {
            // Lọc theo ngày và trạng thái "Da thanh toan"
            var query = db.DonThueXes
                .Include(d => d.Xe)
                .Where(d => d.Xe != null && d.trang_thai == "Da thanh toan");

            if (fromDate.HasValue)
            {
                query = query.Where(d => DbFunctions.TruncateTime(d.ngay_bat_dau) >= DbFunctions.TruncateTime(fromDate.Value));
            }

            if (toDate.HasValue)
            {
                query = query.Where(d => DbFunctions.TruncateTime(d.ngay_bat_dau) <= DbFunctions.TruncateTime(toDate.Value));
            }

            // Chuyển sang LINQ to Objects (ToList) trước khi xử lý tiếp
            var data = query.ToList();

            var doanhThuRaw = data
                .GroupBy(d => d.ngay_bat_dau.Date)  // Dùng .Date được vì đã ToList()
                .Select(g => new
                {
                    Ngay = g.Key,
                    TongTien = g.Sum(d =>
                        d.Xe.gia_thue_ngay *
                        (int)(d.ngay_ket_thuc - d.ngay_bat_dau).TotalDays
                    )
                })
                .OrderBy(g => g.Ngay)
                .ToList();

            var doanhThu = doanhThuRaw
                .Select((item, index) => new DoanhThuReport
                {
                    MaDoanhThu = index + 1,
                    Ngay = item.Ngay,
                    TongTien = item.TongTien
                })
                .ToList();

            return View(doanhThu);
        }





        // GET: DoanhThus/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DoanhThu doanhThu = db.DoanhThus.Find(id);
            if (doanhThu == null)
            {
                return HttpNotFound();
            }
            return View(doanhThu);
        }

        // GET: DoanhThus/Create
        public ActionResult Create()
        {
            ViewBag.id_don_thue_xe = new SelectList(db.DonThueXes, "id", "trang_thai");
            return View();
        }

        // POST: DoanhThus/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,ngay,tong_tien,id_don_thue_xe")] DoanhThu doanhThu)
        {
            if (ModelState.IsValid)
            {
                db.DoanhThus.Add(doanhThu);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.id_don_thue_xe = new SelectList(db.DonThueXes, "id", "trang_thai", doanhThu.id_don_thue_xe);
            return View(doanhThu);
        }

        // GET: DoanhThus/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DoanhThu doanhThu = db.DoanhThus.Find(id);
            if (doanhThu == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_don_thue_xe = new SelectList(db.DonThueXes, "id", "trang_thai", doanhThu.id_don_thue_xe);
            return View(doanhThu);
        }

        // POST: DoanhThus/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,ngay,tong_tien,id_don_thue_xe")] DoanhThu doanhThu)
        {
            if (ModelState.IsValid)
            {
                db.Entry(doanhThu).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_don_thue_xe = new SelectList(db.DonThueXes, "id", "trang_thai", doanhThu.id_don_thue_xe);
            return View(doanhThu);
        }

        // GET: DoanhThus/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DoanhThu doanhThu = db.DoanhThus.Find(id);
            if (doanhThu == null)
            {
                return HttpNotFound();
            }
            return View(doanhThu);
        }

        // POST: DoanhThus/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            DoanhThu doanhThu = db.DoanhThus.Find(id);
            db.DoanhThus.Remove(doanhThu);
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
