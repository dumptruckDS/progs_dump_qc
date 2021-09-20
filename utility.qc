void(string s, string ss) dprint2 = 
	{ dprint(s); dprint(ss); }
void(string s, string ss, string sss) dprint3 = 
	{ dprint(s); dprint(ss); dprint(sss); }
void(string s, string ss, string sss, string ssss) dprint4 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); }
void(string s, string ss, string sss, string ssss, string sssss) dprint5 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); dprint(sssss); }
void(string s, string ss, string sss, string ssss, string sssss, string ssssss) dprint6 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); dprint(sssss); dprint(ssssss);}
void(string s, string ss, string sss, string ssss, string sssss, string ssssss, string sssssss) dprint7 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); dprint(sssss); dprint(ssssss); dprint(sssssss);}
void(string s, string ss, string sss, string ssss, string sssss, string ssssss, string sssssss, string ssssssss) dprint8 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); dprint(sssss); dprint(ssssss); dprint(sssssss); dprint(ssssssss); }
void(string s, string ss, string sss, string ssss, string sssss, string ssssss, string sssssss, string ssssssss, string sssssssss) dprint9 = 
	{ dprint(s); dprint(ss); dprint(sss); dprint(ssss); dprint(sssss); dprint(ssssss); dprint(sssssss); dprint(ssssssss); dprint(sssssssss); }

/**********************************
 Sourced from utility.qc from smej2
 **********************************/


float(float in) bprint_int =
{
	in = floor(in);
	if (in <= 0) return 0;
	
	float digit;
	digit = in - bprint_int(in / 10);
	
	switch(digit) {
	case 9:
		bprint("9"); break;
	case 8:
		bprint("8"); break;
	case 7:
		bprint("7"); break;
	case 6:
		bprint("6"); break;
	case 5:
		bprint("5"); break;
	case 4:
		bprint("4"); break;
	case 3:
		bprint("3"); break;
	case 2:
		bprint("2"); break;
	case 1:
		bprint("1"); break;
	case 0:
		bprint("0"); break;
	}
	
	return in * 10;
}


float(float in, float def) defaultFl = {
	if (in) return in;
	else return def;
}


// shorthand for turning -1 to 0 for keyvalues for which 0 is a valid non-default selection
float(float in) zeroconvert =
{
	if (in == -1) return 0;
	return in;
}
float(float in, float def) zeroconvertdefault =
{
	if (in == -1) return 0;
	if (in == 0) return def;
	return in;
}




// for measuring how large an entity is along an arbitrary vector
// FIXME: this is trash and it returns trash
float(vector v, vector s) BoundsAngleSize =
{
	v_x = fabs(v_x);
	v_y = fabs(v_y);
	v_z = fabs(v_z);
	
	// size is always + + + but this is in case I switch the parameters somewhere
	s_x = fabs(s_x);
	s_y = fabs(s_y);
	s_z = fabs(s_z);
	
	return v * s;
}

//count -4 = numclients in coop
/*void(.float fld) playercount_convert =
{
	if (self.fld != -4) return;
	if (!coop)
		self.fld = 1;
	else
		self.fld = clients;
}
*/


// wonderful stuffcmd code from Honey by czg

/*
=============
stuffcmd_float

This is a horrible hack that I am ashamed of!
===============
*/
void stuffcmd_digit( entity client, float f) =
{
	float d;
	d = floor(f);
	d = mod(d, 10);

	//CLOSE YOUR EYES, HONEY! DON'T LOOK!
	if(d == 0)
		stuffcmd(client, "0");
	else if(d == 1)
		stuffcmd(client, "1");
	else if(d == 2)
		stuffcmd(client, "2");
	else if(d == 3)
		stuffcmd(client, "3");
	else if(d == 4)
		stuffcmd(client, "4");
	else if(d == 5)
		stuffcmd(client, "5");
	else if(d == 6)
		stuffcmd(client, "6");
	else if(d == 7)
		stuffcmd(client, "7");
	else if(d == 8)
		stuffcmd(client, "8");
	else if(d == 9)
		stuffcmd(client, "9");	
}

void stuffcmd_int( entity client, float f, float numdigits) =
{
	
	float tmp;

	
	if(f == 0)
	{
		stuffcmd( client, "0");
		return;
	}

	if(f < 0)
	{
		// Yeah sure.
		stuffcmd( client, "-");
		f = fabs(f);
	}
	
	if(numdigits <= 0)
	{
		tmp = f;
		numdigits = 1;
		while(tmp >= 1){
			tmp = tmp / 10;
			numdigits = numdigits * 10;
		}
	}
	
	//I don't know what I'm thinking here...
	//I need to do this to get zero-padding to work.

	while( numdigits > 1 )
	{
		numdigits = numdigits / 10;
		tmp = f / numdigits;
		stuffcmd_digit( client, tmp);
	}
}

void stuffcmd_float( entity client, float f) =
{
	float intpart, decpart, isNegative;
	
	isNegative = FALSE;
	
	if(f == 0)
	{
		stuffcmd( client, "0");
		return;
	}
	
	if(f < 0)
	{
		// easier this way
		isNegative = TRUE;
		f = fabs(f);
	}	
	
	// 1: stuff the integer part.
	intpart = floor(f);
	if(isNegative) 
		stuffcmd( client, "-");
	stuffcmd_int( client, intpart, 0);
	
	// 2: stuff the decimal point.
	stuffcmd( client, ".");
	
	// 3: stuff the decimal part.
	decpart = mod( f, 1);
	decpart = decpart * 10000;
	stuffcmd_int( client, decpart, 10000);
}
