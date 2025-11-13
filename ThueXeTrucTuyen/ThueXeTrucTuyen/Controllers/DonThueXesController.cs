using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ThueXeTrucTuyen.Models;

namespace ThueXeTrucTuyen.Controllers
{
    public class DonThueXesController : Controller
    {
        private ThueXeTrucTuyenEntities db = new ThueXeTrucTuyenEntities();

        // GET: DonThueXes
        public ActionResult Index()
        {
            var donThueXes = db.DonThueXes
                        .Include(d => d.Xe)
                        .Include(d => d.KhachHang)
                        .ToList();

            

            return View(donThueXes);
        }

        // GET: DonThueXes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonThueXe donThueXe = db.DonThueXes.Find(id);
            if (donThueXe == null)
            {
                return HttpNotFound();
            }
            return View(donThueXe);
        }

        // GET: DonThueXes/Create
        public ActionResult Create()
        {
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten");
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe");
            // Lấy danh sách nhân viên
            ViewBag.NhanVienList = new SelectList(db.NhanViens, "id", "ho_ten");

            // Danh sách trạng thái
            ViewBag.TrangThaiList = new SelectList(new[]
            {
                new SelectListItem { Value = "Da thanh toan", Text = "Đã thanh toán" },
                new SelectListItem { Value = "Chua thanh toan", Text = "Chưa thanh toán" }
            }, "Value", "Text");
            return View();
        }

        // POST: DonThueXes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,id_khach_hang,id_xe,ngay_bat_dau,ngay_ket_thuc,id_nhan_vien_xu_ly,trang_thai")] DonThueXe donThueXe)
        {
            if (ModelState.IsValid)
            {
                var xe = db.Xes.Find(donThueXe.id_xe);
                if (xe != null)
                {
                    var soNgay = (donThueXe.ngay_ket_thuc - donThueXe.ngay_bat_dau).Days;
                    if (soNgay <= 0)
                    {
                        ModelState.AddModelError("", "Ngày kết thúc phải sau ngày bắt đầu.");
                        goto ErrorView;
                    }

                    donThueXe.tong_tien = soNgay * xe.gia_thue_ngay;

                    // Nếu trạng thái chưa được gán, gán mặc định là "Chua Thanh Toan"
                    if (string.IsNullOrEmpty(donThueXe.trang_thai))
                    {
                        donThueXe.trang_thai = "Chua Thanh Toan"; // Default value
                    }

                    db.DonThueXes.Add(donThueXe);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("", "Xe không tồn tại.");
                    goto ErrorView;
                }
            }

        ErrorView:
            // Truyền danh sách nhân viên vào ViewBag dưới dạng SelectList
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", donThueXe.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", donThueXe.id_xe);

            return View(donThueXe);
        }



        // GET: DonThueXes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonThueXe donThueXe = db.DonThueXes.Find(id);
            if (donThueXe == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", donThueXe.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", donThueXe.id_xe);
            return View(donThueXe);
        }

        // POST: DonThueXes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,id_khach_hang,id_xe,ngay_bat_dau,ngay_ket_thuc,tong_tien,trang_thai,id_nhan_vien_xu_ly")] DonThueXe donThueXe)
        {
            if (ModelState.IsValid)
            {
                db.Entry(donThueXe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", donThueXe.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", donThueXe.id_xe);
            return View(donThueXe);
        }

        // GET: DonThueXes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonThueXe donThueXe = db.DonThueXes.Find(id);
            if (donThueXe == null)
            {
                return HttpNotFound();
            }
            return View(donThueXe);
        }

        // POST: DonThueXes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            DonThueXe donThueXe = db.DonThueXes.Find(id);
            db.DonThueXes.Remove(donThueXe);
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
