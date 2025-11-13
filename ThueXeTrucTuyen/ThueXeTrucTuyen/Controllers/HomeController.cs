using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace ThueXeTrucTuyen.Controllers
{
    public class HomeController : Controller
    {
       
        public ActionResult Index()
        {
            if (Session["user"] == null)
            {
                return RedirectToAction("DangNhap");

            }
            else return View();
        }

        

        public ActionResult DangNhap()
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangNhap(string user, string password)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();

            try
            {
                // Tài khoản admin cố định
                if (user == "admin" && password == "admin@123")
                {
                    Session["user"] = user;
                    return RedirectToAction("Index", "Xes");
                }

                // Kiểm tra tài khoản trong bảng NhanVien
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT tai_khoan FROM NhanVien WHERE tai_khoan = @Username AND mat_khau = @Password";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", user);
                        cmd.Parameters.AddWithValue("@Password", password);

                        var result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            Session["user"] = result.ToString(); // Lưu tên đăng nhập
                            return RedirectToAction("Index", "Xes");
                        }
                        else
                        {
                            TempData["Error"] = "Tài khoản hoặc mật khẩu không đúng";
                            return View();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
                return View();
            }
        }



        public ActionResult DangXuat()
        {
            //xóa session
            Session.Remove("user");
            //Xóa session form
            FormsAuthentication.SignOut();
            return RedirectToAction("DangNhap" ,"Home");
        }
    }
}