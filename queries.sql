CREATE TABLE
  users (
    id serial primary key,
    role varchar(20) check (role in ('Admin', 'Customer')) not null default 'customer',
    Name varchar(50) not null,
    Email varchar(100) not null unique,
    Password varchar(255) not null,
    phone_number varchar(20),
    created_at timestamp default current_timestamp
  );

create table
  Vehicles (
    id serial primary key,
    vehicle_name varchar(50) not null,
    vehicle_type varchar(20) not null check (vehicle_type in ('car', 'bike', 'truck')),
    model varchar(50) not null,
    Registration_number varchar(20) not null unique,
    Rental_price_per_day int not null,
    Availability_status varchar(20) not null default 'available' check (
      Availability_status in ('available', 'rented', 'maintenance')
    ),
    created_at timestamp default current_timestamp
  );

create table
  Bookings (
    id serial primary key,
    user_id int not null,
    vehicle_id int not null,
    start_date date not null,
    end_date date not null,
    booking_status varchar(20) check (
      booking_status in ('Pending', 'confirmed', 'completed', 'canceled')
    ) default 'pending',
    Total_Booking_Cost decimal(10, 2) not null,
    foreign key (user_id) references Users (id) on delete cascade,
    foreign key (vehicle_id) references Vehicles (id) on delete cascade
  )
INSERT INTO
  Users (role, Name, Email, Password, phone_number)
VALUES
  (
    'Customer',
    'John Doe',
    'john.doe@email.com',
    'hashed_password_1',
    '+8801711111111'
  ),
  (
    'Customer',
    'Jane Smith',
    'jane.smith@email.com',
    'hashed_password_2',
    '+8801722222222'
  ),
  (
    'Admin',
    'Admin User',
    'admin@rental.com',
    'hashed_admin_pass',
    '+8801733333333'
  ),
  (
    'Customer',
    'Bob Johnson',
    'bob.j@email.com',
    'hashed_password_3',
    '+8801744444444'
  );

INSERT INTO
  Vehicles (
    vehicle_name,
    vehicle_type,
    model,
    Registration_number,
    Rental_price_per_day,
    Availability_status
  )
VALUES
  (
    'Toyota Corolla',
    'car',
    'Corolla 2023',
    'DHA-12345',
    2500,
    'available'
  ),
  (
    'Honda Civic',
    'car',
    'Civic 2022',
    'DHA-67890',
    2800,
    'available'
  ),
  (
    'Yamaha FZ',
    'bike',
    'FZ-S 2023',
    'DHA-11112',
    800,
    'available'
  ),
  (
    'BMW X5',
    'car',
    'X5 2024',
    'DHA-33334',
    5000,
    'maintenance'
  ),
  (
    'Tata Truck',
    'truck',
    'Truck 2022',
    'DHA-55556',
    4000,
    'available'
  ),
  (
    'Suzuki Hayate',
    'bike',
    'Hayate 2023',
    'DHA-77778',
    600,
    'available'
  ),
  (
    'Toyota Hilux',
    'car',
    'Hilux 2023',
    'DHA-99990',
    3500,
    'available'
  ),
  (
    'Royal Enfield',
    'bike',
    'Classic 350',
    'DHA-12123',
    1000,
    'rented'
  ),
  (
    'Maruti Suzuki',
    'car',
    'Swift 2023',
    'DHA-44444',
    2000,
    'available'
  ),
  (
    'Hero Honda',
    'bike',
    'Splendor 2023',
    'DHA-55555',
    500,
    'available'
  );

INSERT INTO
  Bookings (
    user_id,
    vehicle_id,
    start_date,
    end_date,
    booking_status,
    Total_Booking_Cost
  )
VALUES
  (
    1,
    1,
    '2024-01-15',
    '2024-01-20',
    'completed',
    12500.00
  ),
  (
    1,
    2,
    '2024-02-01',
    '2024-02-03',
    'completed',
    5600.00
  ),
  (
    2,
    1,
    '2024-02-10',
    '2024-02-12',
    'completed',
    5000.00
  ),
  (
    1,
    1,
    '2024-03-05',
    '2024-03-07',
    'confirmed',
    5000.00
  ),
  (
    4,
    3,
    '2024-02-20',
    '2024-02-25',
    'completed',
    4000.00
  ),
  (
    2,
    5,
    '2024-03-01',
    '2024-03-05',
    'Pending',
    16000.00
  ),
  (
    1,
    2,
    '2024-03-10',
    '2024-03-12',
    'confirmed',
    5600.00
  ),
  (
    3,
    6,
    '2024-03-15',
    '2024-03-16',
    'Pending',
    600.00
  ),
  (
    4,
    7,
    '2024-03-18',
    '2024-03-20',
    'Pending',
    7000.00
  ),
  (
    1,
    1,
    '2024-03-25',
    '2024-03-27',
    'confirmed',
    5000.00
  );


-- Join

select
  bookings.id as booking_id,
  Users.Name as customer_name,
  Vehicles.vehicle_name as vehicle_name,
  Vehicles.vehicle_type as vehicle_type,
  Vehicles.model as vehicle_model,
  Bookings.start_date,
  Bookings.end_date,
  Bookings.Total_Booking_Cost,
  Bookings.booking_status
from
  Bookings
  inner join Users on Bookings.user_id = Users.id
  inner join Vehicles on Bookings.vehicle_id = Vehicles.id
order by
  Bookings.id;


-- EXISTS
select Vehicles.id as vehicle_id,
Vehicles.vehicle_name,
Vehicles.vehicle_type,
Vehicles.model,
Vehicles.Registration_number,
Vehicles.Rental_price_per_day,
Vehicles.availability_status

from Vehicles
where not exists(
    select 1 from Bookings
    where Bookings.vehicle_id = Vehicles.id);

-- WHERE
select 
    Vehicles.id as vehicle_id,
    Vehicles.vehicle_name,
    Vehicles.vehicle_type,
    Vehicles.model,
    Vehicles.Registration_number,
    Vehicles.Rental_price_per_day,
    Vehicles.Availability_status 
from Vehicles
where Vehicles.vehicle_type = 'car' 
  and Vehicles.Availability_status = 'available';

--Group by AND Having
select 
    Vehicles.id as vehicle_id,
    Vehicles.vehicle_name,
    Vehicles.vehicle_type, 
    Vehicles.model,
    count(Bookings.id) as total_bookings,
    sum(Bookings.Total_Booking_Cost) as total_revenue
from Vehicles
left join Bookings on Vehicles.id = Bookings.vehicle_id 
group by 
    Vehicles.id, 
    Vehicles.vehicle_name, 
    Vehicles.vehicle_type, 
    Vehicles.model
having count(Bookings.id) > 2 
order by total_bookings desc;
