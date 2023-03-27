require "rqrcode"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :initialize_qrcode, only: [:qr_generator, :qr_code_download]

  def home
    hash = Transaction.group_by_day(:created_at).sum(:price_cents)
    @amount_by_day = hash.each do |key, value|
      hash[key] = value / 100
    end

    hash = Transaction.group_by_week(:created_at).sum(:price_cents)
    @amount_by_week = hash.each do |key, value|
      hash[key] = value / 100
    end

    hash = Transaction.group_by_month(:created_at).sum(:price_cents)
    @amount_by_month = hash.each do |key, value|
      hash[key] = value / 100
    end

  end

  def qr_generator
    # NOTE: showing with default options specified explicitly
    @svg = @qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 5,
      standalone: true,
      use_path: true
    )
  end

  def qr_code_download
    send_data @qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 5,
      standalone: true,
      use_path: true
    ), filename: "qr_code.svg", type: "image/svg+xml"
  end

  def playground
  end

  def initialize_qrcode
    @qrcode = RQRCode::QRCode.new("https://buy.stripe.com/test_bIYdS7gBY4KL2cg9AA")
  end
end
