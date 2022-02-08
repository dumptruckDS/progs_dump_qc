
inline void(entity client, float density, vector color) csf_save = {
	client.csf_color = color;
	client.csf_density = density;
}

inline void(entity client) csf_apply = {
	stuffcmd(client, "\nv_cshift ");
	stuffcmd(client, ftos(client.csf_color_x));
	stuffcmd(client, " ");
	stuffcmd(client, ftos(client.csf_color_y));
	stuffcmd(client, " ");
	stuffcmd(client, ftos(client.csf_color_z));
	stuffcmd(client, " ");
	stuffcmd(client, ftos(client.csf_density));
	stuffcmd(client, "\n");
}

void(entity client, float density, vector color) csf_set = {
	csf_save(client, density, color);
	csf_apply(client);
}

void() csfcontroller_think = {
	
	entity e = self.owner;

	if (self.pain_finished > time && e.csf_density != self.csf_density) {
		
		float density;
		vector color;
		
		float fraction = 1 - (self.pain_finished - time) / self.speed; //wat

		density = lerpHermite(e.csf_density, self.csf_density, fraction);
		color = lerpVectorHermite(e.csf_color, self.csf_color, fraction);

		csf_set(e, density, color);

		self.nextthink = time + 0.04;
	}
	else {
		csf_set(e, self.csf_density, self.csf_color);
	}

}


void(entity client) csfcontroller_start = {
	if (client.csfcontroller.classname == "csfcontroller" && client.csfcontroller.owner == client)
		return;

	entity e = spawn();
	client.csfcontroller = e;
	e.owner = client;
	e.classname = "csfcontroller";
	e.think = csfcontroller_think;
}


void(entity client, float density, vector color, float spd) csf_fade = {
	csfcontroller_start(client);

	entity ct = client.csfcontroller;

	ct.speed = spd;
	ct.pain_finished = time + spd;
	ct.csf_color = color;
	ct.csf_density = density;
	ct.nextthink = time + 0.04;
}




