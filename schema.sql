-- ==========================================================
-- 화이트샌즈 주문 조회용 테이블 생성 스크립트
-- Supabase 대시보드 > SQL Editor 에서 실행하세요
-- ==========================================================

create table if not exists orders (
  id bigint generated always as identity primary key,
  shipped_date text,              -- A: 출고일
  order_no_sabangnet text,        -- B: 주문번호(사방넷)
  order_no_mall text,             -- C: 주문번호(쇼핑몰)
  mall text,                      -- D: 쇼핑몰
  receiver_name text,             -- E: 수령인
  courier text,                   -- F: 택배사
  tracking_no text,               -- G: 운송장번호
  receiver_phone text,            -- H: 받는분연락처
  receiver_phone2 text,           -- I: 받는분기타연락처
  address text,                   -- J: 주소
  delivery_message text,          -- K: 배송메세지
  product_name text,              -- L: 상품명
  quantity numeric,               -- M: 수량
  payment_amount numeric,         -- N: 결제금액
  product_name_qoo10 text,        -- O: 큐텐(한글상품명)
  barcode text,                   -- P: 바코드
  qoo10_barcode text,             -- Q: 큐텐바코드
  product_code text,              -- R: 상품코드
  mall_ref text,                  -- S: 쇼핑몰(참고용)
  product_color_code text,        -- T: 상품컬러코드
  product_name_collected text,    -- U: 상품명(수집)
  option_collected text,          -- V: 옵션(수집)
  orderer_name text,              -- W: 주문자명
  category text,                  -- X: 구분
  order_datetime text,            -- Y: 주문일시
  orderer_phone1 text,            -- Z: 주문자 연락처(1)
  orderer_phone2 text,            -- AA: 주문자 연락처(2)
  not_shipped text,               -- AB: 미출고
  uploaded_at timestamptz default now()
);

-- 검색 성능을 위한 인덱스 (검색에 쓰는 컬럼들)
create index if not exists idx_orders_order_no_sabangnet on orders (order_no_sabangnet);
create index if not exists idx_orders_order_no_mall on orders (order_no_mall);
create index if not exists idx_orders_receiver_name on orders (receiver_name);
create index if not exists idx_orders_tracking_no on orders (tracking_no);
create index if not exists idx_orders_receiver_phone on orders (receiver_phone);
create index if not exists idx_orders_receiver_phone2 on orders (receiver_phone2);
create index if not exists idx_orders_orderer_phone1 on orders (orderer_phone1);
create index if not exists idx_orders_orderer_phone2 on orders (orderer_phone2);

-- ==========================================================
-- RLS (행 단위 보안) 설정
-- 로그인(Supabase Auth)한 사용자만 읽고 쓸 수 있도록 제한합니다.
-- 로그인 안 한 사람은 이 테이블에 전혀 접근할 수 없습니다.
-- ==========================================================
alter table orders enable row level security;

-- 로그인한 사용자만 조회 허용
create policy "Allow authenticated read" on orders
  for select using (auth.role() = 'authenticated');

-- 로그인한 사용자만 업로드(등록) 허용
create policy "Allow authenticated insert" on orders
  for insert with check (auth.role() = 'authenticated');

-- 로그인한 사용자만 전체 교체 업로드 시 삭제 허용
create policy "Allow authenticated delete" on orders
  for delete using (auth.role() = 'authenticated');

-- ==========================================================
-- 사용자(로그인 계정) 만들기
-- Supabase 대시보드 > Authentication > Users > Add user 에서
-- 실무자별 이메일/비밀번호를 직접 생성하세요.
-- (자체 회원가입은 막고, 관리자가 계정을 발급하는 방식을 권장합니다)
--
-- Authentication > Providers > Email 에서
-- "Allow new users to sign up" 옵션을 꺼두면 회원가입 페이지 없이
-- 관리자가 만들어준 계정으로만 로그인할 수 있습니다.
-- ==========================================================
