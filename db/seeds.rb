User.create(email: "developer@gmail.com", password: "123456789", role: "Admin", name: "Developer")
User.create(email: "premiumdrycleaners80@gmail.com", password: "123456789", role: "Admin", name: "Premium")

Item.create([
	{name: "Long Coat"},
	{name: "Suit-3P"},
	{name: "Suit-2P"},
	{name: "Coat"},
	{name: "Jacket-F/S"},
	{name: "Jacket-H/S"},
	{name: "Sadri"},
	{name: "Shawal"},
	{name: "School Blazer"},
	{name: "Sweter-F/S"},
	{name: "Sweter-H/S"},
	{name: "Paint Woolen"},
	{name: "Shirt Woolen"},
	{name: "Sherwani-3P"},
	{name: "Pant"},
	{name: "Shirt"},
	{name: "Kurta"},
	{name: "Pajama"},
	{name: "Kurta-Silk"},
	{name: "Pajama-Silk"},
	{name: "Lehnga-3P"},
	{name: "Ladies Kurta"},
	{name: "Salwar"},
	{name: "Duptta"},
	{name: "Saree"},
	{name: "Blouse"},
	{name: "Long Frock"},
	{name: "Carton"},
	{name: "Blanket Double Bed"},
	{name: "Blanket Single Bed"},
	{name: "Carpet Sq Feet"},
	{name: "Sofa -Per sit"}
])
Service.create([{name: "DYE"},{name: "ROLL PRESS/CHARAK"},{name: "Rafoo"}, {name: "DRY CLEAN"},{name: "ESTEAM PRESS"}])

Organization.create( name: "60 feet", address: "Lucknow")
