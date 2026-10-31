import React from 'react';
import { Printer, X, QrCode, Clock, AlertTriangle, CheckCircle2, Building2 } from 'lucide-react';
import { useHomestay } from '../context/HomestayContext';
import {
  formatVND,
  formatDate,
  formatDateTime,
  getDepositDeadline,
  getDepositRemainingMinutes,
  isBookingOverdue12Hours,
  generateVietQRUrl,
  useLockScroll,
  getNowVietnamISO,
} from '../utils/helpers';

interface DepositPaymentRequestModalProps {
  maDon: string;
  onClose: () => void;
}

export const DepositPaymentRequestModal: React.FC<DepositPaymentRequestModalProps> = ({
  maDon,
  onClose,
}) => {
  const { bookings, customers, rooms, bankConfig } = useHomestay();

  const booking = bookings.find((b) => b.MaDon === maDon);
  const customer = customers.find((c) => c.MaKH === booking?.MaKH);
  const room = rooms.find((r) => r.MaPhong === booking?.MaPhong);

  useLockScroll(Boolean(booking));

  if (!booking) return null;

  const handlePrint = () => {
    window.print();
  };

  const isOverdue = isBookingOverdue12Hours(booking.ThoiGianTaoDon);
  const deadline = getDepositDeadline(booking.ThoiGianTaoDon);
  const remainingMinutes = getDepositRemainingMinutes(booking.ThoiGianTaoDon);
  const hoursLeft = Math.floor(Math.max(0, remainingMinutes) / 60);
  const minsLeft = Math.max(0, remainingMinutes) % 60;

  // Số tiền cọc cần nộp (30% tiền phòng trừ đi số đã thu nếu có)
  const depositDue = Math.max(0, booking.TienCocYeuCau - booking.DaThu);
  const transferContent = booking.MaDon; // Nội dung chuyển khoản theo mã đơn

  const qrUrl = generateVietQRUrl(
    bankConfig.bankCode || 'ICB',
    bankConfig.accountNo || '108876543210',
    bankConfig.accountName || 'CHICSTAY HOMESTAY',
    depositDue,
    transferContent
  );

  const requestVoucherCode = `YC${booking.MaDon.slice(2)}`;
  const currentVietnamDateStr = getNowVietnamISO();

  return (
    <div className="fixed inset-0 bg-slate-900/80 backdrop-blur-md z-50 flex items-center justify-center p-4 print:p-0 print:bg-white overscroll-contain">
      <div className="bg-white rounded-2xl max-w-3xl w-full max-h-[92vh] flex flex-col shadow-2xl overflow-hidden border border-slate-200 relative isolate print:max-h-none print:overflow-visible print:shadow-none print:m-0 print:w-full print:max-w-none print:rounded-none print:border-none">
        
        {/* Modal Top Bar - Hidden in Print */}
        <div className="flex-shrink-0 bg-white px-6 sm:px-8 py-4 flex items-center justify-between border-b border-slate-200 z-20 print:hidden">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-blue-50 border border-blue-200 flex items-center justify-center text-blue-700">
              <QrCode className="w-4 h-4" />
            </div>
            <div>
              <h2 className="text-base font-extrabold text-slate-900 leading-tight">
                PHIẾU YÊU CẦU THANH TOÁN CỌC (VIETQR)
              </h2>
              <p className="text-[11px] text-slate-500">
                Đơn {booking.MaDon} · Hạn xác nhận 12 giờ kể từ thời điểm tạo đơn
              </p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-xl shadow-xs flex items-center gap-1.5 cursor-pointer transition-colors"
              title="In phiếu trên giấy A4 hoặc lưu file PDF"
            >
              <Printer className="w-4 h-4" />
              <span>In Phiếu</span>
            </button>
            <button
              onClick={onClose}
              className="p-1.5 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-slate-100 cursor-pointer transition-colors"
              title="Đóng modal"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Printable Voucher Body */}
        <div className="flex-1 overflow-y-auto p-6 sm:p-8 space-y-5 text-slate-800 text-xs overscroll-contain print:overflow-visible print:p-6 print:text-black">
          
          {/* Header Thông tin Homestay & Tiêu đề phiếu */}
          <div className="flex items-start justify-between pb-4 border-b-2 border-slate-900">
            <div>
              <div className="text-2xl font-black tracking-tight text-blue-700 uppercase print:text-blue-900">
                CHICSTAY HOMESTAY
              </div>
              <p className="text-[11px] text-slate-600 mt-1">
                Địa chỉ: Số 18 Đường Mây Ngàn, P.3, TP. Đà Lạt · Hotline: 0988.123.456
              </p>
              <p className="text-[11px] text-slate-600">
                Email: booking@chicstay.vn · Website: chicstay.vn
              </p>
            </div>
            <div className="text-right">
              <span className="text-base font-black text-slate-900 block uppercase">
                PHIẾU YÊU CẦU THANH TOÁN CỌC
              </span>
              <span className="font-mono text-xs font-bold text-blue-700 block mt-0.5 print:text-blue-900">
                Mã phiếu: {requestVoucherCode}
              </span>
              <span className="text-[11px] text-slate-500 block mt-0.5">
                Ngày lập: {formatDate(currentVietnamDateStr)}
              </span>
            </div>
          </div>

          {/* Khách hàng & Thông tin lưu trú (Tương tự Hóa đơn tất toán) */}
          <div className="grid grid-cols-2 gap-4 p-3.5 bg-slate-50 rounded-xl border border-slate-200 print:bg-white print:border-slate-300">
            <div>
              <span className="font-bold text-slate-500 uppercase text-[10px] block">
                KHÁCH HÀNG:
              </span>
              <strong className="text-sm text-slate-900 block mt-0.5">
                {customer?.HoTen || 'Khách vãng lai'}
              </strong>
              <div className="text-slate-600 text-[11px] mt-0.5">
                Số ĐT: {customer?.SoDienThoai || '--'} · CCCD: {customer?.CCCD || '--'}
              </div>
              <div className="text-slate-500 text-[11px]">
                Địa chỉ: {customer?.DiaChi || 'Việt Nam'}
              </div>
            </div>

            <div>
              <span className="font-bold text-slate-500 uppercase text-[10px] block">
                THÔNG TIN LƯU TRÚ:
              </span>
              <strong className="text-sm text-slate-900 block mt-0.5">
                Phòng {booking.MaPhong} ({room?.TenPhong || booking.MaPhong}) - {room?.LoaiPhong || 'Standard'}
              </strong>
              <div className="text-slate-600 text-[11px] mt-0.5">
                Nhận: {formatDate(booking.NgayNhanPhong)} → Trả: {formatDate(booking.NgayTraPhong)} ({booking.SoDem} đêm)
              </div>
              <div className="text-slate-500 text-[11px]">
                Số lượng: {booking.SoKhach} khách · Mã đơn: <strong className="text-blue-700 font-mono">{booking.MaDon}</strong>
              </div>
            </div>
          </div>

          {/* B. Bảng chi tiết thanh toán tiền phòng & tỷ lệ cọc */}
          <div className="space-y-1.5">
            <h3 className="text-xs font-bold text-slate-900 uppercase tracking-wide">
              B. Chi tiết tiền phòng & tỷ lệ đặt cọc
            </h3>
            <table className="w-full text-left border-collapse border border-slate-200 print:border-slate-300">
              <thead className="bg-slate-100 font-bold border-b border-slate-200 text-slate-700 print:bg-slate-50">
                <tr>
                  <th className="py-2 px-3">NỘI DUNG THANH TOÁN</th>
                  <th className="py-2 px-3 text-center">ĐVT</th>
                  <th className="py-2 px-3 text-center">SL</th>
                  <th className="py-2 px-3 text-right">ĐƠN GIÁ</th>
                  <th className="py-2 px-3 text-right">THÀNH TIỀN</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200 print:divide-slate-300">
                <tr>
                  <td className="py-2.5 px-3">
                    <strong>Tiền phòng {booking.MaPhong}</strong>
                    <span className="block text-[11px] text-slate-500">
                      Từ {formatDate(booking.NgayNhanPhong)} đến {formatDate(booking.NgayTraPhong)} ({booking.SoDem} đêm)
                    </span>
                  </td>
                  <td className="py-2.5 px-3 text-center">Đêm</td>
                  <td className="py-2.5 px-3 text-center">{booking.SoDem}</td>
                  <td className="py-2.5 px-3 text-right tabular-nums">
                    {formatVND(room ? room.GiaPhong : booking.TienPhong / booking.SoDem)}
                  </td>
                  <td className="py-2.5 px-3 text-right font-bold tabular-nums">
                    {formatVND(booking.TienPhong)}
                  </td>
                </tr>

                <tr>
                  <td className="py-2.5 px-3">
                    <strong>Tỷ lệ đặt cọc phòng theo quy định CHICSTAY</strong>
                    <span className="block text-[11px] text-slate-500">
                      Bắt buộc 30% tiền phòng (làm tròn đến hàng nghìn đồng theo chính sách)
                    </span>
                  </td>
                  <td className="py-2.5 px-3 text-center">%</td>
                  <td className="py-2.5 px-3 text-center font-bold">30%</td>
                  <td className="py-2.5 px-3 text-right text-slate-400">-</td>
                  <td className="py-2.5 px-3 text-right font-bold tabular-nums text-blue-700">
                    {formatVND(booking.TienCocYeuCau)}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          {/* Tóm tắt tiền cọc & Hạn thanh toán */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-start">
            
            {/* Box Hạn thanh toán 12 giờ */}
            <div className={`p-4 rounded-xl border space-y-2 ${
              isOverdue
                ? 'bg-rose-50 border-rose-300 text-rose-900'
                : 'bg-amber-50/70 border-amber-300 text-amber-950'
            }`}>
              <div className="flex items-center gap-2 font-black text-xs uppercase tracking-wide">
                <Clock className="w-4 h-4 shrink-0 text-amber-700" />
                <span>Thời hạn thanh toán cọc (12 giờ)</span>
              </div>
              <div className="text-[11px] space-y-1">
                <div className="flex justify-between">
                  <span className="text-slate-600">Thời điểm tạo đơn:</span>
                  <span className="font-semibold">{formatDateTime(booking.ThoiGianTaoDon)}</span>
                </div>
                <div className="flex justify-between pt-1 border-t border-amber-200/60">
                  <span className="font-bold text-amber-950">Hạn chót thanh toán:</span>
                  <strong className="text-rose-700 text-xs font-black">
                    {formatDateTime(deadline)}
                  </strong>
                </div>
              </div>

              <div className="pt-1.5 border-t border-amber-200">
                {isOverdue ? (
                  <div className="flex items-center gap-1.5 text-rose-700 font-bold text-[11px]">
                    <AlertTriangle className="w-4 h-4 shrink-0" />
                    <span>ĐƠN ĐÃ QUÁ HẠN 12 GIỜ VÀ ĐÃ BỊ TỰ ĐỘNG HỦY.</span>
                  </div>
                ) : (
                  <div className="flex items-center justify-between text-[11px] font-semibold text-emerald-800 bg-emerald-100/70 px-2.5 py-1 rounded-lg">
                    <span>Thời gian còn lại:</span>
                    <span className="font-bold text-emerald-900 tabular-nums">
                      {hoursLeft > 0 ? `${hoursLeft} giờ ` : ''}{minsLeft} phút
                    </span>
                  </div>
                )}
              </div>
            </div>

            {/* Box Tổng kết số tiền */}
            <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-1.5 text-xs">
              <div className="flex justify-between text-slate-600">
                <span>Tổng tiền phòng dự tính:</span>
                <span className="tabular-nums font-semibold">{formatVND(booking.TienPhong)}</span>
              </div>
              <div className="flex justify-between text-slate-700 font-medium">
                <span>Tiền cọc yêu cầu (30%):</span>
                <span className="tabular-nums font-bold text-blue-700">{formatVND(booking.TienCocYeuCau)}</span>
              </div>
              {booking.DaThu > 0 && (
                <div className="flex justify-between text-emerald-700 font-semibold">
                  <span>Tiền cọc đã ghi nhận trước:</span>
                  <span className="tabular-nums">-{formatVND(booking.DaThu)}</span>
                </div>
              )}
              <div className="flex justify-between font-black text-sm border-t-2 border-slate-900 pt-2 text-slate-950">
                <span className="uppercase text-blue-900">SỐ TIỀN CỌC CẦN CHUYỂN:</span>
                <span className="tabular-nums text-base text-rose-600 font-black">
                  {formatVND(depositDue)}
                </span>
              </div>
            </div>

          </div>

          {/* C. Thông tin chuyển khoản VietQR & Mã QR Quét thực tế */}
          <div className="p-4 rounded-xl bg-blue-50/50 border border-blue-200 print:bg-white print:border-slate-300 space-y-3">
            <div className="flex items-center gap-2 font-bold text-xs text-blue-900 uppercase tracking-wide border-b border-blue-200 pb-2">
              <QrCode className="w-4 h-4 text-blue-700" />
              <span>C. Thông tin chuyển khoản VietQR (Quét mã tự động)</span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-12 gap-4 items-center">
              
              {/* QR Image Column */}
              <div className="sm:col-span-5 flex flex-col items-center justify-center text-center space-y-1.5">
                <div className="p-2 bg-white rounded-xl border border-blue-200 shadow-xs inline-block print:border-slate-300">
                  <img
                    src={qrUrl}
                    alt={`VietQR ${booking.MaDon}`}
                    className="w-44 h-44 object-contain"
                  />
                </div>
                <span className="text-[10px] text-slate-500 italic block">
                  Mở ứng dụng Ngân hàng hoặc MoMo / VNPay để quét mã
                </span>
              </div>

              {/* Bank Account Details Column */}
              <div className="sm:col-span-7 space-y-2 text-xs">
                <div className="bg-white p-3 rounded-lg border border-blue-100 shadow-2xs space-y-1.5 print:border-slate-200">
                  <div className="flex items-center gap-1.5 text-blue-800 font-bold text-[11px]">
                    <Building2 className="w-3.5 h-3.5" />
                    <span>NGÂN HÀNG THỤ HƯỞNG CHÍNH THỨC</span>
                  </div>
                  <div className="font-bold text-slate-900 text-sm">
                    {bankConfig.bankName}
                  </div>
                  <div className="text-[11px] text-slate-500">
                    Mã chuẩn liên ngân hàng: <strong className="font-mono text-slate-800">{bankConfig.bankCode}</strong>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-white p-2.5 rounded-lg border border-blue-100 text-[11px] print:border-slate-200">
                    <span className="text-slate-500 block text-[10px]">CHỦ TÀI KHOẢN:</span>
                    <strong className="text-slate-900 font-bold block mt-0.5 uppercase">
                      {bankConfig.accountName}
                    </strong>
                  </div>
                  <div className="bg-white p-2.5 rounded-lg border border-blue-100 text-[11px] print:border-slate-200">
                    <span className="text-slate-500 block text-[10px]">SỐ TÀI KHOẢN:</span>
                    <strong className="text-blue-700 font-mono font-black text-sm block mt-0.5">
                      {bankConfig.accountNo}
                    </strong>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-white p-2.5 rounded-lg border border-blue-100 text-[11px] print:border-slate-200">
                    <span className="text-slate-500 block text-[10px]">SỐ TIỀN CỌC:</span>
                    <strong className="text-rose-600 font-bold text-sm block mt-0.5 tabular-nums">
                      {formatVND(depositDue)}
                    </strong>
                  </div>
                  <div className="bg-white p-2.5 rounded-lg border border-blue-100 text-[11px] print:border-slate-200">
                    <span className="text-slate-500 block text-[10px]">NỘI DUNG CHUYỂN KHOẢN:</span>
                    <strong className="text-emerald-700 font-mono font-bold text-sm block mt-0.5">
                      {transferContent}
                    </strong>
                  </div>
                </div>

                <p className="text-[10px] text-slate-500 italic">
                  * Quý khách vui lòng điền chính xác nội dung <strong className="text-blue-800">{transferContent}</strong> để hệ thống đối soát và xác nhận đơn phòng nhanh chóng nhất.
                </p>
              </div>

            </div>
          </div>

          {/* F. Ghi chú quy định (Bắt buộc theo yêu cầu nghiệp vụ) */}
          <div className="p-3.5 bg-amber-50/80 rounded-xl border border-amber-300 text-amber-950 text-xs space-y-1 print:bg-white print:border-slate-300">
            <span className="font-bold uppercase text-[10px] tracking-wide block text-amber-900 flex items-center gap-1">
              <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
              F. GHI CHÚ QUY ĐỊNH ĐẶT CỌC:
            </span>
            <p className="leading-relaxed text-[11px] font-medium text-slate-800">
              Vui lòng chuyển khoản đúng số tiền và nội dung thanh toán trước thời hạn quy định. Đơn đặt phòng chỉ được xác nhận sau khi CHICSTAY kiểm tra và ghi nhận đủ tiền cọc. Đơn chưa được xác nhận đủ cọc khi hết hạn 12 giờ sẽ tự động hủy.
            </p>
          </div>

          {/* Phần ký nhận xác nhận (Tương tự Hóa đơn tất toán) */}
          <div className="pt-6 border-t border-slate-200 grid grid-cols-2 text-center text-xs print:pt-4">
            <div>
              <span className="font-bold text-slate-700 block uppercase">KHÁCH HÀNG</span>
              <span className="text-[10px] text-slate-400 italic block mt-0.5">(Ký và ghi rõ họ tên)</span>
              <div className="h-16 flex items-end justify-center font-semibold text-slate-900">
                {customer?.HoTen}
              </div>
            </div>

            <div>
              <span className="font-bold text-slate-700 block uppercase">ĐẠI DIỆN HOMESTAY CHICSTAY</span>
              <span className="text-[10px] text-slate-400 italic block mt-0.5">(Ký và xác nhận)</span>
              <div className="h-16 flex items-end justify-center font-bold text-blue-700">
                Quản lý Chicstay
              </div>
            </div>
          </div>

          {/* Lời cảm ơn */}
          <div className="text-center text-[11px] text-slate-400 pt-4 border-t border-slate-100">
            Cảm ơn quý khách đã tin tưởng và lựa chọn Chicstay Homestay. Hẹn gặp lại quý khách!
          </div>

        </div>

      </div>
    </div>
  );
};
