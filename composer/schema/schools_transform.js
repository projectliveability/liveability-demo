function transform(line) {
	var values=line.split(',');
	var obj = new Object();
	obj.Name = values[0];
	obj.Categories = values[1];
	obj.Address = values[2];
	obj.City = values[3];	
	obj.State = values[4];
	obj.Postcode = values[5];
	obj.Phone=values[6];
	obj.Website=values[7];
	obj.Email=values[8];	
	obj.Fax = values[9];	
	obj.Latitude = values[10];
	obj.Longitude = values[11];
	obj.Employees = values[12];
	obj.Established = values[13];	
	obj.Licence_No=values[14];
	obj.ABN_Status = values[15];
	obj.ABN = values[16];
	obj.ABN_Name = values[17];
	obj.Accuracy = values[18];	
	obj.ABN_2 = values[19];
	obj.ACN = values[20];	
	var jsonString= JSON.stringify(obj);
	return jsonString;
}	





















