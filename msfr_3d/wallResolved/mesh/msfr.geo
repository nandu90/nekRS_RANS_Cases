// Core geometric details
h_cl 			= 1.6;
h_peripheral 	= 2.65;
r_wall 			= 1.264;
theta_wall 		= Pi/1.75; //the arch angle of the outer wall
dh_inlet 		= 0.235; // this is not the channel width, but the width of the vertical cross section.
r_core 			= 1.054;
x_outlet 		= 1.785; 
h_extru 		= 0.6;


// Model setup parameters
h_bl			=0.025;				// Boundary layer thickness
ratio_bl		=1.5;
n_bl			=6;
n_Azi			=22;
n_curve			=10; //10
n_width			=7; //7
n_neck			=6; //6
n_elbow 		=6; //6
n_extru			=10; //10

// Points on the centerline
Point(1) = {0, -h_cl/2, 0, 1.0};
Point(2) = {0, -(h_cl/2-h_bl), 0, 1.0};
Point(3) = {0, 0, 0, 1.0};
Point(4) = {0, h_cl/2-h_bl, 0, 1.0};
Point(5) = {0, h_cl/2, 0, 1.0};
//+
Line(1) = {1,2}; Line(2) = {5,4}; Transfinite Curve {1:2}= n_bl Using Progression ratio_bl;
Line(3) = {2,3}; Line(4) = {4,3}; Transfinite Curve {3:4}= n_curve Using Progression 1.0;

nWallPatch=0; 	nInletPatch=0; 	nOutletPatch=0; nFluidVolume=0;
startSurface=0; startVolume=0;



Function fillSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
Return

Function fillWallSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	wall[nWallPatch]=startSurface; nWallPatch=nWallPatch+1;
Return

Function fillInletSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	inlet[nInletPatch]=startSurface; nInletPatch=nInletPatch+1;
Return

Function fillOutletSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	outlet[nOutletPatch]=startSurface; nOutletPatch=nOutletPatch+1;
Return

Function fillVolume
	startVolume=startVolume+1;
	Surface Loop (startVolume) = {s1,s2,s3,s4,s5,s6};
	Volume (startVolume) = {startVolume};
	fluid[nFluidVolume]=startVolume; nFluidVolume=nFluidVolume+1;
Return

Function printEntities
	Printf("pref =%g; pref1 =%g; pref2 =%g; pref3 =%g; pref4 =%g; pref5 =%g; pref6 =%g;", pref,pref1,pref2,pref3,pref4,pref5,pref6);
	Printf("lref1 =%g; lref2 =%g; lref3 =%g; lref4 =%g; lref5=%g; lref6=%g", lref1,lref2,lref3,lref4,lref5,lref6);
	Printf("lref7 =%g; lref8 =%g; lref9 =%g", lref7,lref8,lref9);
	Printf("sref =%g; sref1 =%g; sref2 =%g; sref3 =%g; sref4 =%g", sref,sref1,sref2,sref3,sref4);
Return

Function fan
// outlet channels
	pref3=newp; Printf("pref3 =%g", pref3);
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet, 		  0, 1.0};
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet+h_bl,   0, 1.0}; 	Line(newl) = {pref3  ,pref3+1};
	Point(newp) = {x_outlet,  h_peripheral/2-h_bl, 			  0, 1.0};          
	Point(newp) = {x_outlet,  h_peripheral/2, 				  0, 1.0};  Line(newl) = {pref3+3,pref3+2};

	Point(newp) = {x_outlet, h_peripheral/2-dh_inlet-0.15, 0, 1.0}; // center of the arch
	height1 = h_peripheral/2-dh_inlet-0.15;
	pref4=newp; Printf("pref4 =%g", pref4);
	Point(newp) = {x_outlet+0.15, 					height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height1, 0, 1.0};	Line(newl) = {pref4  ,pref4+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height1, 0, 1.0};	Line(newl) = {pref4+3,pref4+2};

	height2 = height1-h_extru;
	Point(newp) = {x_outlet+0.15, 					height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height2, 0, 1.0};	Line(newl) = {pref4+4,pref4+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height2, 0, 1.0};	Line(newl) = {pref4+7,pref4+6};

// inlet part
	pref5=newp; Printf("pref5 =%g", pref5);
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet), 	  0, 1.0};    	
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet+h_bl), 0, 1.0};	Line(newl) = {pref5  ,pref5+1};
	Point(newp) = {x_outlet, -(h_peripheral/2-h_bl), 		  0, 1.0};			
	Point(newp) = {x_outlet, -(h_peripheral/2), 			  0, 1.0};	Line(newl) = {pref5+3,pref5+2};

	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet-0.15), 0, 1.0}; // center of the arch
	height3 = -height1;
	pref6=newp; Printf("pref6 =%g", pref6);
	Point(newp) = {x_outlet+0.15, 					height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height3, 0, 1.0}; 	Line(newl) = {pref6  ,pref6+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height3, 0, 1.0};	Line(newl) = {pref6+3,pref6+2};
	
	height4 = -height2;
	Point(newp) = {x_outlet+0.15, 					height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height4, 0, 1.0};	Line(newl) = {pref6+4,pref6+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height4, 0, 1.0};	Line(newl) = {pref6+7,pref6+6};
// boundary layer lines are connected first from the wall to the interior.
	lref2=newl; Printf("lref2 =%g", lref2);
	Transfinite Curve {lref2-12:lref2-1}= n_bl Using Progression ratio_bl;  

	Line(newl) = {pref3+1,pref3+2};
	Line(newl) = {pref4+1,pref4+2};
	Line(newl) = {pref4+5,pref4+6};

	Line(newl) = {pref5+1,pref5+2};
	Line(newl) = {pref6+1,pref6+2};
	Line(newl) = {pref6+5,pref6+6};

	lref3=newl; Printf("lref3 =%g", lref3);
	Transfinite Curve {lref2:lref3-1}= n_width Using Progression 1.0;

// connecting inlet and outlet necks 
	Line(newl) = {pref1-1,pref3  };
	Line(newl) = {pref2-1,pref3+1};
	Line(newl) = {pref2+1,pref3+2};
	Line(newl) = {pref2  ,pref3+3};

	Line(newl) = {pref   ,pref5  };
	Line(newl) = {pref1  ,pref5+1};
	Line(newl) = {pref2+3,pref5+2};
	Line(newl) = {pref2+2,pref5+3};

	lref4=newl; Printf("lref4 =%g", lref4);
	Transfinite Curve {lref3:lref4-1}= n_neck Using Progression 1.0;

// connecting inlet and outlet elbows
	Circle(newl) = {pref3  ,pref4-1,pref4  };
	Circle(newl) = {pref3+1,pref4-1,pref4+1};
	Circle(newl) = {pref3+2,pref4-1,pref4+2};
	Circle(newl) = {pref3+3,pref4-1,pref4+3};

	Circle(newl) = {pref5  ,pref6-1,pref6  };
	Circle(newl) = {pref5+1,pref6-1,pref6+1};
	Circle(newl) = {pref5+2,pref6-1,pref6+2};
	Circle(newl) = {pref5+3,pref6-1,pref6+3};

	lref5=newl; Printf("lref5=%g", lref5);
	Transfinite Curve {lref4:lref5-1}= n_elbow Using Progression 1.0;

// connecting inlet and outlet extrusion pipes
	Line(newl) = {pref4  ,pref4+4};
	Line(newl) = {pref4+1,pref4+5};
	Line(newl) = {pref4+2,pref4+6};
	Line(newl) = {pref4+3,pref4+7};

	Line(newl) = {pref6  ,pref6+4};
	Line(newl) = {pref6+1,pref6+5};
	Line(newl) = {pref6+2,pref6+6};
	Line(newl) = {pref6+3,pref6+7};

	lref6=newl; Printf("lref6=%g", lref6);
	Transfinite Curve {lref5:lref6-1}= n_extru Using Progression 1.0;

// filling surfaces related to inlet/outlet neck parts
	l1 = -(lref1+4);  l2 = lref3;     l3 = (lref2-12);  l4 = -(lref3+1);   Call fillWallSurface; 
	l1 = -(lref1+7);  l2 = lref3+1;   l3 = lref2;       l4 = -(lref3+2);   Call fillWallSurface;
	l1 = lref1+5;     l2 = lref3+2;   l3 = -(lref2-11); l4 = -(lref3+3);   Call fillWallSurface;
//
	l1 = lref1;  	  l2 = lref3+5;   l3 =-(lref2-6);   l4 = -(lref3+4);   Call fillWallSurface;
	l1 = lref1+8;     l2 = lref3+6;   l3 =-(lref2+3);   l4 = -(lref3+5);   Call fillWallSurface;
	l1 =-(lref1+6);   l2 = lref3+7;   l3 = (lref2-5);   l4 = -(lref3+6);   Call fillWallSurface;
// filling surfaces related to inlet/outlet elbow parts
	l1 = -(lref2-12); l2 = lref4;     l3 = (lref2-10);  l4 = -(lref4+1);   Call fillWallSurface;
	l1 = -lref2;      l2 = lref4+1;   l3 = (lref2+1);   l4 = -(lref4+2);   Call fillWallSurface;
	l1 = lref2-11;    l2 = lref4+2;   l3 =-(lref2-9);   l4 = -(lref4+3);   Call fillWallSurface;
//
	l1 = (lref2-6);   l2 = lref4+5;   l3 =-(lref2-4);   l4 = -(lref4+4);   Call fillWallSurface;
	l1 = (lref2+3);   l2 = lref4+6;   l3 =-(lref2+4);   l4 = -(lref4+5);   Call fillWallSurface;
	l1 =-(lref2-5);   l2 = lref4+7;   l3 = (lref2-3);   l4 = -(lref4+6);   Call fillWallSurface;
// filling surfaces related to inlet/outlet extrusion parts
	l1 =-(lref2-10);  l2 = lref5;     l3 = (lref2-8);   l4 = -(lref5+1);   Call fillWallSurface;
	l1 =-(lref2+1);   l2 = lref5+1;   l3 = (lref2+2);   l4 = -(lref5+2);   Call fillWallSurface;
	l1 = (lref2-9);   l2 = lref5+2;   l3 =-(lref2-7);   l4 = -(lref5+3);   Call fillWallSurface;
//
	l1 = (lref2-4);   l2 = lref5+5;   l3 =-(lref2-2);   l4 = -(lref5+4);   Call fillWallSurface;
	l1 = (lref2+4);   l2 = lref5+6;   l3 =-(lref2+5);   l4 = -(lref5+5);   Call fillWallSurface;
	l1 =-(lref2-3);   l2 = lref5+7;   l3 = (lref2-1);   l4 = -(lref5+6);   Call fillWallSurface;
Return

// The wall curve
Function curvedWall
	pcenter=newp; Printf("pcenter =%g", pcenter);
	Point(newp) = {r_core+r_wall, 0, 0, 1.0};
	pref=newp; Printf("pref =%g", pref);
	x1 = r_core+r_wall-r_wall*Cos(theta_wall/4); y1 = r_wall*Sin(theta_wall/4); 
	x2 = r_core+r_wall-r_wall*Cos(theta_wall/2); y2 = r_wall*Sin(theta_wall/2); 
	Point(newp) = {x2, 		-y2, 0, 1.0};
	Point(newp) = {x1, 		-y1, 0, 1.0}; 
	Point(newp) = {r_core, 	  0, 0, 1.0}; 
	Point(newp) = {x1,   	 y1, 0, 1.0};
	Point(newp) = {x2, 		 y2, 0, 1.0};
	lref=newl; Printf("lref =%g", lref);
	Circle(newl) = {pref  ,pcenter,pref+1};
	Circle(newl) = {pref+1,pcenter,pref+2};
	Circle(newl) = {pref+2,pcenter,pref+3};
	Circle(newl) = {pref+3,pcenter,pref+4};
	
	r_tmp = Sqrt((r_core+r_wall-x2)^2.0+(y2+1.5*h_bl)^2); r_new = r_core+r_wall-r_tmp;
	pref1=newp; Printf("pref1 =%g", pref1);
	x3 = r_core+r_wall-r_tmp*Cos(theta_wall/4); y3 = r_tmp*Sin(theta_wall/4); 
	Point(newp) = {x2, 		-(y2 + 1.5*h_bl), 	0, 1.0};
	Point(newp) = {x3, 		-y3, 				0, 1.0};
	Point(newp) = {r_new,    0, 				0, 1.0};
	Point(newp) = {x3, 		 y3, 				0, 1.0};
	Point(newp) = {x2, 		 y2 + 1.5*h_bl, 	0, 1.0};
	Circle(newl) = {pref1  ,pcenter,pref1+1};
	Circle(newl) = {pref1+1,pcenter,pref1+2};
	Circle(newl) = {pref1+2,pcenter,pref1+3};
	Circle(newl) = {pref1+3,pcenter,pref1+4};
	Transfinite Curve {lref:lref+7}= n_curve Using Progression 1.0;
	
	lref1=newl; Printf("lref1 =%g", lref1);
	For ipoint In {0:4:1}
		Line(newl) = {pref+ipoint, pref1+ipoint};
	EndFor

// BL faces parallel to the radial direction (z>0)
	l1 = lref+2;      l2 = lref1+1+2; l3 = -(lref+4+2); l4 = -(lref1+2);   Call fillSurface; 
	l1 = lref+3;      l2 = lref1+1+3; l3 = -(lref+4+3); l4 = -(lref1+3);   Call fillSurface;
// (z<0)
	l1 = lref+1;      l2 = lref1+2;   l3 = -(lref+5);   l4 = -(lref1+1);   Call fillSurface;
	l1 = lref;        l2 = lref1+1;   l3 = -(lref+4);   l4 = -(lref1);     Call fillSurface;
// the top and bottom points at the outlet/inlet faces 
	x4 = x2; 
	y4 = h_peripheral/2 - ((x_outlet - x4) * (h_peripheral-h_cl)/2/x_outlet);
	pref2=newp; Printf("pref2 =%g", pref2);
	Point(newp) = {x4,  y4, 0, 1.0}; Point(newp) = {x4,   y4-h_bl,  0, 1.0}; Line(newl) = {pref2  ,pref2+1};
	Point(newp) = {x4, -y4, 0, 1.0}; Point(newp) = {x4, -(y4-h_bl), 0, 1.0}; Line(newl) = {pref2+2,pref2+3};
	Transfinite Curve {lref1:lref1+6}= n_bl Using Progression ratio_bl;  
	Line(newl) = {pref2-1,pref2+1};
	Line(newl) = {pref1  ,pref2+3};
	Transfinite Curve {lref1+7:lref1+8}= n_width Using Progression 1.0;

	pref_beg=newp; Printf("pref_beg =%g", pref_beg);
	Call fan;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
	Rotate {{0,1,0}, {x4,y4,0}, -Pi/16} { Point{pref_beg:pref_end}; }

	// Call printEntities;
	pref_beg=newp; Printf("pref_beg =%g", pref_beg);
	Call fan;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
	Rotate {{0,1,0}, {x4,y4,0}, Pi/16} { Point{pref_beg:pref_end}; }

Return 

nwedge = 15;
islice = 0; 
For i In {nwedge:0:-1}
    sref=startSurface+1; Printf("sref =%g", sref);
	Call curvedWall;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);	
	Rotate {{0,1,0}, {0,0,0}, i*Pi/8} { Point{pcenter:pref_end}; }
	
	Printf("islice =%g", islice);
	If(islice > 0)
		lref7=newl; Printf("lref7 =%g", lref7);
		For iedge In {pref:pref2+3:1}
			Line(newl) = {iedge-67,iedge};
		EndFor
		ldelta3=139; If(islice==1) ldelta3=101; EndIf
		
		sref1=startSurface+1; Printf("sref1 =%g", sref1);
        For iface In {0:4:1} // boundary layer faces along the curved wall
			l1 = -(lref7+iface);	l2 = lref1+iface-ldelta3;	l3 = lref7+5+iface;			l4 = -(lref1+iface);	Call fillSurface;
		EndFor
        For iface In {0:3:1} // patches of the curved wall
			l1 = (lref+iface);		l2 = -(lref7+1+iface);		l3 = -(l1-ldelta3); 	 	l4 = lref7+iface;		Call fillWallSurface;
			l1 = (lref+iface+4);	l2 = -(lref7+6+iface);		l3 = -(l1-ldelta3); 		l4 = lref7+iface+5;		Call fillSurface;
		EndFor

		sdelta=99; If(islice==1) sdelta=40; EndIf
		s1=sref+3;		s2=s1-sdelta;		s3=sref1;		s4=sref1+1;		s5=sref1+5;		s6=sref1+6; 	Call fillVolume;
		s1=sref+2;		s2=s1-sdelta;		s3=sref1+1;		s4=sref1+2;		s5=sref1+7;		s6=sref1+8; 	Call fillVolume;
		s1=sref;   		s2=s1-sdelta;		s3=sref1+2;		s4=sref1+3;		s5=sref1+9;		s6=sref1+10; 	Call fillVolume;
		s1=sref+1;		s2=s1-sdelta;		s3=sref1+3;		s4=sref1+4;		s5=sref1+11;	s6=sref1+12; 	Call fillVolume;

// patches when the inlet/outlet channels meeting the bulk core
		sref2=startSurface+1; Printf("sref2 =%g", sref2);
		l1 = lref1+7;			l2 = -(lref7+11);		l3 = -(l1-ldelta3); 	 l4 = lref7+9;		Call fillSurface;
		l1 = -(lref1+5);		l2 = -(lref7+10);		l3 = (-l1-ldelta3); 	 l4 = lref7+11;		Call fillSurface;

		l1 = -(lref1+8);		l2 = -(lref7+5);		l3 = (-l1-ldelta3); 	 l4 = lref7+13;		Call fillSurface;
		l1 = (lref1+6);	     	l2 = -(lref7+13);		l3 = -(l1-ldelta3); 	 l4 = lref7+12;		Call fillSurface;

		lref8=newl; Printf("lref8 =%g", lref8);
		For iedge In {pref3:pref3+3:1}
			Line(newl) = {iedge-93,iedge};
		EndFor
		For iedge In {pref4:pref4+7:1}
			Line(newl) = {iedge-93,iedge};
		EndFor

// patches between outlet necks and elbows
		ldelta4=181; If(islice==1) ldelta4=143; EndIf

		sref3=startSurface+1; Printf("sref3 =%g", sref3);
		l1 = lref8;		l2 = lref1+51;		l3 = -(lref8+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+1;	l2 = lref2;			l3 = -(lref8+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+2;	l2 = -(lref1+52);	l3 = -(lref8+3);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref7+4;	l2 = lref3;			l3 = -(lref7+14);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref7+9;	l2 = (lref3+1);		l3 = -(lref7+15);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+11;	l2 = (lref3+2);		l3 = -(lref7+16);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+10;	l2 = (lref3+3);		l3 = -(lref7+17);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// patches between outlet elbows and extrusions	
		l1 = lref8+4;	l2 = lref1+53;		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+5;	l2 = lref2+1;		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+6;	l2 = -(lref1+54);	l3 = -(lref8+7);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref8;		l2 = lref4;			l3 = -(lref8+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref8+1;	l2 = (lref4+1);		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+2;	l2 = (lref4+2);		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+3;	l2 = (lref4+3);		l3 = -(lref8+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// outlet face patches
		l1 = lref8+8;	l2 = lref1+55;		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
		l1 = lref8+9;	l2 = lref2+2;		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
		l1 = lref8+10;	l2 = -(lref1+56);	l3 = -(lref8+11);	l4 =(-l2-ldelta4);	Call fillOutletSurface;

		l1 = lref8+4;	l2 = lref5;			l3 = -(lref8+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref8+5;	l2 = (lref5+1);		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+6;	l2 = (lref5+2);		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+7;	l2 = (lref5+3);		l3 = -(lref8+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

		sdelta1=117; If(islice==1) sdelta1=58; EndIf
		s1=sref+22;		s2=s1-sdelta1;		s3=sref1+4;		s4=sref3;		s5=sref3+3;		s6=sref3+4; 	Call fillVolume;
		s1=sref+23;		s2=s1-sdelta1;		s3=sref2;		s4=sref2+5;		s5=sref3+4;		s6=sref3+5; 	Call fillVolume;
		s1=sref+24;   	s2=s1-sdelta1;		s3=sref2+1;		s4=sref2+6;		s5=sref3+5;		s6=sref3+6; 	Call fillVolume;

		s1=sref+28;		s2=s1-sdelta1;		s3=sref3;		s4=sref3+7;		s5=sref3+10;	s6=sref3+11; 	Call fillVolume;
		s1=sref+29;		s2=s1-sdelta1;		s3=sref3+1;		s4=sref3+8;		s5=sref3+11;	s6=sref3+12; 	Call fillVolume;
		s1=sref+30;   	s2=s1-sdelta1;		s3=sref3+2;		s4=sref3+9;		s5=sref3+12;	s6=sref3+13; 	Call fillVolume;

		s1=sref+34;		s2=s1-sdelta1;		s3=sref3+7;		s4=sref3+14;	s5=sref3+17;	s6=sref3+18; 	Call fillVolume;
		s1=sref+35;		s2=s1-sdelta1;		s3=sref3+8;		s4=sref3+15;	s5=sref3+18;	s6=sref3+19; 	Call fillVolume;
		s1=sref+36;   	s2=s1-sdelta1;		s3=sref3+9;		s4=sref3+16;	s5=sref3+19;	s6=sref3+20; 	Call fillVolume;

		lref9=newl; Printf("lref9 =%g", lref9);
		For iedge In {pref5:pref5+3:1}
			Line(newl) = {iedge-93,iedge};
		EndFor
		For iedge In {pref6:pref6+7:1}
			Line(newl) = {iedge-93,iedge};
		EndFor		

// patches between inlet necks and elbows
		sref4=startSurface+1; Printf("sref4 =%g", sref4);
		l1 = lref9;		l2 = lref1+57;		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+1;	l2 = lref2+3;		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+2;	l2 = -(lref1+58);	l3 = -(lref9+3);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref7;  	l2 = lref3+4;		l3 = -lref9;		l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref7+5;	l2 = (lref3+5);		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+13;	l2 = (lref3+6);		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+12;	l2 = (lref3+7);		l3 = -(lref9+3);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// // patches between inlet elbows and extrusions	
		l1 = lref9+4;	l2 = lref1+59;		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+5;	l2 = lref2+4;		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+6;	l2 = -(lref1+60);	l3 = -(lref9+7);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref9;		l2 = lref4+4;		l3 = -(lref9+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref9+1;	l2 = (lref4+5);		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+2;	l2 = (lref4+6);		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+3;	l2 = (lref4+7);		l3 = -(lref9+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// // inlet face patches
		l1 = lref9+8;	l2 = lref1+61;		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillInletSurface;
		l1 = lref9+9;	l2 = lref2+5;		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillInletSurface;
		l1 = lref9+10;	l2 = -(lref1+62);	l3 = -(lref9+11);	l4 =(-l2-ldelta4);	Call fillInletSurface;

		l1 = lref9+4;	l2 = lref5+4;		l3 = -(lref9+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref9+5;	l2 = (lref5+5);		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+6;	l2 = (lref5+6);		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+7;	l2 = (lref5+7);		l3 = -(lref9+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

		s1=sref+25;		s2=s1-sdelta1;		s3=sref1;		s4=sref4;		s5=sref4+3;		s6=sref4+4; 	Call fillVolume;
		s1=sref+26;		s2=s1-sdelta1;		s3=sref2+2;		s4=sref4+1;		s5=sref4+4;		s6=sref4+5; 	Call fillVolume;
		s1=sref+27;   	s2=s1-sdelta1;		s3=sref2+3;		s4=sref4+2;		s5=sref4+5;		s6=sref4+6; 	Call fillVolume;

		s1=sref+31;		s2=s1-sdelta1;		s3=sref4;		s4=sref4+7;		s5=sref4+10;	s6=sref4+11; 	Call fillVolume;
		s1=sref+32;		s2=s1-sdelta1;		s3=sref4+1;		s4=sref4+8;		s5=sref4+11;	s6=sref4+12; 	Call fillVolume;
		s1=sref+33;   	s2=s1-sdelta1;		s3=sref4+2;		s4=sref4+9;		s5=sref4+12;	s6=sref4+13; 	Call fillVolume;

		s1=sref+37;		s2=s1-sdelta1;		s3=sref4+7;		s4=sref4+14;	s5=sref4+17;	s6=sref4+18; 	Call fillVolume;
		s1=sref+38;		s2=s1-sdelta1;		s3=sref4+8;		s4=sref4+15;	s5=sref4+18;	s6=sref4+19; 	Call fillVolume;
		s1=sref+39;   	s2=s1-sdelta1;		s3=sref4+9;		s4=sref4+16;	s5=sref4+19;	s6=sref4+20; 	Call fillVolume;

		// Call printEntities;		
		Transfinite Curve {lref7:lref9+11}= n_Azi Using Bump 0.02;
	EndIf //islice 

	islice = islice + 1; 
	If(islice == 16)
		lref7=newl; Printf("lref7 =%g", lref7);
		For iedge In {pref:pref2+3:1}
			Line(newl) = {iedge-1005,iedge};
		EndFor
		ldelta3=2047;	
		sref1=startSurface+1; Printf("sref1 =%g", sref1);
        For iface In {0:4:1} // boundary layer faces along the curved wall
			l1 = -(lref7+iface);	l2 = lref1+iface-ldelta3;	l3 = lref7+5+iface;			l4 = -(lref1+iface);	Call fillSurface;
		EndFor
        For iface In {0:3:1} // patches of the curved wall
			l1 = (lref+iface);		l2 = -(lref7+1+iface);		l3 = -(l1-ldelta3); 	 	l4 = lref7+iface;		Call fillWallSurface;
			l1 = (lref+iface+4);	l2 = -(lref7+6+iface);		l3 = -(l1-ldelta3); 		l4 = lref7+iface+5;		Call fillSurface;
		EndFor

		sdelta=1426; 
		s1=sref+3;		s2=s1-sdelta;		s3=sref1;		s4=sref1+1;		s5=sref1+5;		s6=sref1+6; 	Call fillVolume;
		s1=sref+2;		s2=s1-sdelta;		s3=sref1+1;		s4=sref1+2;		s5=sref1+7;		s6=sref1+8; 	Call fillVolume;
		s1=sref;   		s2=s1-sdelta;		s3=sref1+2;		s4=sref1+3;		s5=sref1+9;		s6=sref1+10; 	Call fillVolume;
		s1=sref+1;		s2=s1-sdelta;		s3=sref1+3;		s4=sref1+4;		s5=sref1+11;	s6=sref1+12; 	Call fillVolume;

// patches when the inlet/outlet channels meeting the bulk core
		sref2=startSurface+1; Printf("sref2 =%g", sref2);
		l1 = lref1+7;			l2 = -(lref7+11);		l3 = -(l1-ldelta3); 	 l4 = lref7+9;		Call fillSurface;
		l1 = -(lref1+5);		l2 = -(lref7+10);		l3 = (-l1-ldelta3); 	 l4 = lref7+11;		Call fillSurface;

		l1 = -(lref1+8);		l2 = -(lref7+5);		l3 = (-l1-ldelta3); 	 l4 = lref7+13;		Call fillSurface;
		l1 = (lref1+6);	     	l2 = -(lref7+13);		l3 = -(l1-ldelta3); 	 l4 = lref7+12;		Call fillSurface;

		lref8=newl; Printf("lref8 =%g", lref8);
		For iedge In {pref2+4:pref2+7:1}
			Line(newl) = {iedge-979,iedge};
		EndFor
		For iedge In {pref2+9:pref2+16:1}
			Line(newl) = {iedge-979,iedge};
		EndFor

// patches between outlet necks and elbows
		ldelta4=2005;

		sref3=startSurface+1; Printf("sref3 =%g", sref3);
		l1 = lref8;		l2 = lref1+9;		l3 = -(lref8+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+1;	l2 = lref1+21;		l3 = -(lref8+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+2;	l2 = -(lref1+10);	l3 = -(lref8+3);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref7+4;	l2 = lref1+27;		l3 = -(lref7+14);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref7+9;	l2 = (lref1+28);	l3 = -(lref7+15);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+11;	l2 = (lref1+29);	l3 = -(lref7+16);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+10;	l2 = (lref1+30);	l3 = -(lref7+17);	l4 =-(l2-ldelta4);	Call fillWallSurface;
// patches between outlet elbows and extrusions	
		l1 = lref8+4;	l2 = lref1+11;		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+5;	l2 = lref1+22;		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+6;	l2 = -(lref1+12);	l3 = -(lref8+7);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref8;		l2 = lref1+35;		l3 = -(lref8+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref8+1;	l2 = (lref1+36);	l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+2;	l2 = (lref1+37);	l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+3;	l2 = (lref1+38);	l3 = -(lref8+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// outlet face patches
		l1 = lref8+8;	l2 = lref1+13;		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
		l1 = lref8+9;	l2 = lref1+23;		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
		l1 = lref8+10;	l2 = -(lref1+14);	l3 = -(lref8+11);	l4 =(-l2-ldelta4);	Call fillOutletSurface;

		l1 = lref8+4;	l2 = lref1+43;		l3 = -(lref8+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref8+5;	l2 = (lref1+44);	l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+6;	l2 = (lref1+45);	l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref8+7;	l2 = (lref1+46);	l3 = -(lref8+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

		sdelta1=1408;
		s1=sref+4;		s2=s1-sdelta1;		s3=sref1+4;		s4=sref3;		s5=sref3+3;		s6=sref3+4; 	Call fillVolume;
		s1=sref+5;		s2=s1-sdelta1;		s3=sref2;		s4=sref3+1;		s5=sref3+4;		s6=sref3+5; 	Call fillVolume;
		s1=sref+6;   	s2=s1-sdelta1;		s3=sref2+1;		s4=sref3+2;		s5=sref3+5;		s6=sref3+6; 	Call fillVolume;

		s1=sref+10;		s2=s1-sdelta1;		s3=sref3;		s4=sref3+7;		s5=sref3+10;	s6=sref3+11; 	Call fillVolume;
		s1=sref+11;		s2=s1-sdelta1;		s3=sref3+1;		s4=sref3+8;		s5=sref3+11;	s6=sref3+12; 	Call fillVolume;
		s1=sref+12;   	s2=s1-sdelta1;		s3=sref3+2;		s4=sref3+9;		s5=sref3+12;	s6=sref3+13; 	Call fillVolume;

		s1=sref+16;		s2=s1-sdelta1;		s3=sref3+7;		s4=sref3+14;	s5=sref3+17;	s6=sref3+18; 	Call fillVolume;
		s1=sref+17;		s2=s1-sdelta1;		s3=sref3+8;		s4=sref3+15;	s5=sref3+18;	s6=sref3+19; 	Call fillVolume;
		s1=sref+18;   	s2=s1-sdelta1;		s3=sref3+9;		s4=sref3+16;	s5=sref3+19;	s6=sref3+20; 	Call fillVolume;

		lref9=newl; Printf("lref9 =%g", lref9);
		For iedge In {pref2+17:pref2+20:1}
			Line(newl) = {iedge-979,iedge};
		EndFor
		For iedge In {pref2+22:pref2+29:1}
			Line(newl) = {iedge-979,iedge};
		EndFor	

// patches between inlet necks and elbows
		sref4=startSurface+1; Printf("sref4 =%g", sref4);
		l1 = lref9;		l2 = lref1+15;		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+1;	l2 = lref1+24;		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+2;	l2 = -(lref1+16);	l3 = -(lref9+3);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref7;  	l2 = lref1+31;		l3 = -lref9;		l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref7+5;	l2 = (lref1+32);	l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+13;	l2 = (lref1+33);	l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref7+12;	l2 = (lref1+34);	l3 = -(lref9+3);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// // patches between inlet elbows and extrusions	
		l1 = lref9+4;	l2 = lref1+17;		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+5;	l2 = lref1+25;		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+6;	l2 = -(lref1+18);	l3 = -(lref9+7);	l4 =(-l2-ldelta4);	Call fillSurface;

		l1 = lref9;		l2 = lref1+39;		l3 = -(lref9+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref9+1;	l2 = (lref1+40);		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+2;	l2 = (lref1+41);		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+3;	l2 = (lref1+42);		l3 = -(lref9+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

// // // inlet face patches
		l1 = lref9+8;	l2 = lref1+19;		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillInletSurface;
		l1 = lref9+9;	l2 = lref1+26;		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillInletSurface;
		l1 = lref9+10;	l2 = -(lref1+20);	l3 = -(lref9+11);	l4 =(-l2-ldelta4);	Call fillInletSurface;

		l1 = lref9+4;	l2 = lref1+47;		l3 = -(lref9+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
		l1 = lref9+5;	l2 = (lref1+48);	l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+6;	l2 = (lref1+49);	l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillSurface;
		l1 = lref9+7;	l2 = (lref1+50);	l3 = -(lref9+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

		s1=sref+7;		s2=s1-sdelta1;		s3=sref1;		s4=sref4;		s5=sref4+3;		s6=sref4+4; 	Call fillVolume;
		s1=sref+8;		s2=s1-sdelta1;		s3=sref2+2;		s4=sref4+1;		s5=sref4+4;		s6=sref4+5; 	Call fillVolume;
		s1=sref+9;   	s2=s1-sdelta1;		s3=sref2+3;		s4=sref4+2;		s5=sref4+5;		s6=sref4+6; 	Call fillVolume;

		s1=sref+13;		s2=s1-sdelta1;		s3=sref4;		s4=sref4+7;		s5=sref4+10;	s6=sref4+11; 	Call fillVolume;
		s1=sref+14;		s2=s1-sdelta1;		s3=sref4+1;		s4=sref4+8;		s5=sref4+11;	s6=sref4+12; 	Call fillVolume;
		s1=sref+15;   	s2=s1-sdelta1;		s3=sref4+2;		s4=sref4+9;		s5=sref4+12;	s6=sref4+13; 	Call fillVolume;

		s1=sref+19;		s2=s1-sdelta1;		s3=sref4+7;		s4=sref4+14;	s5=sref4+17;	s6=sref4+18; 	Call fillVolume;
		s1=sref+20;		s2=s1-sdelta1;		s3=sref4+8;		s4=sref4+15;	s5=sref4+18;	s6=sref4+19; 	Call fillVolume;
		s1=sref+21;   	s2=s1-sdelta1;		s3=sref4+9;		s4=sref4+16;	s5=sref4+19;	s6=sref4+20; 	Call fillVolume;

		Call printEntities;		
		Transfinite Curve {lref7:lref9+11}= n_Azi Using Bump 0.02;
	EndIf
EndFor
prefwall = newp; Printf("prefwall =%g", prefwall-1);
lrefwall = newl;
srefwall = startSurface;

islice = 0;
Function msfrCore   		// create points in the bulk core
    itag = islice%4;
	pcore1=newp; Printf("pcore1 =%g", pcore1);
	lcore1=newl; Printf("lcore1 =%g", lcore1);
	eta=3.0;

    If (itag == 0) 
		x5 = x_outlet/eta;
		y5 = h_peripheral/2 - ((x_outlet - x5) * (h_peripheral-h_cl)/2/x_outlet);	
		Point(newp) = {x5, y5, 0, 1.0};  Point(newp) = {x5, y5-h_bl, 0, 1.0};   	Line(newl) = {pcore1  ,pcore1+1};
		Point(newp) = {x5, -y5, 0, 1.0}; Point(newp) = {x5, -(y5-h_bl), 0, 1.0};	Line(newl) = {pcore1+2,pcore1+3};
		Point(newp) = {x5, 0, 0, 1.0};	
		x6 = x5/2;
		y6 = h_peripheral/2 - ((x_outlet - x6) * (h_peripheral-h_cl)/2/x_outlet);
		Point(newp) = {x6, y6, 0, 1.0};  Point(newp) = {x6, y6-h_bl, 0, 1.0};       Line(newl) = {pcore1+5,pcore1+6};
		Point(newp) = {x6, -y6, 0, 1.0}; Point(newp) = {x6, -(y6-h_bl), 0, 1.0}; 	Line(newl) = {pcore1+7,pcore1+8};
		Point(newp) = {x6, 0, 0, 1.0}; 
		Transfinite Curve {lcore1:lcore1+3}= n_bl Using Progression ratio_bl;
		Line(newl) = {pcore1+4,pcore1+1}; Line(newl) = {pcore1+4,pcore1+3};
		Line(newl) = {pcore1+9,pcore1+6}; Line(newl) = {pcore1+9,pcore1+8};
		Transfinite Curve {lcore1+4:lcore1+7}= n_curve Using Progression 1.0;
		Line(newl) = {pcore1  ,pcore1+5}; Line(newl) = {pcore1+1,pcore1+6};
		Line(newl) = {pcore1+2,pcore1+7}; Line(newl) = {pcore1+3,pcore1+8};
		Line(newl) = {pcore1+4,pcore1+9};
		Line(newl) = {5       ,pcore1+5}; Line(newl) = {4       ,pcore1+6};
		Line(newl) = {1       ,pcore1+7}; Line(newl) = {2       ,pcore1+8};
		Line(newl) = {3       ,pcore1+9};
		Transfinite Curve {lcore1+8:lcore1+17}= n_Azi Using Progression 1.0;
// core patches sitting in the radial direction	
		l1 =  lcore1;		l2 = lcore1+9;		l3 = -(lcore1+2);	l4 =-(lcore1+8);	Call fillSurface;
		l1 =  lcore1+1;		l2 = lcore1+11;		l3 = -(lcore1+3);	l4 =-(lcore1+10);	Call fillSurface;
		l1 =  lcore1+2;		l2 = -(lcore1+14);	l3 = -2;			l4 = (lcore1+13);	Call fillSurface;
		l1 =  lcore1+3;		l2 = -(lcore1+16);	l3 = -1;			l4 = (lcore1+15);	Call fillSurface;	
		l1 =-(lcore1+4);	l2 =  (lcore1+12);	l3 = (lcore1+6);	l4 =-(lcore1+9);	Call fillSurface;
		l1 = (lcore1+5);	l2 =  (lcore1+11);	l3 =-(lcore1+7);	l4 =-(lcore1+12);	Call fillSurface;
		l1 =-(lcore1+6);	l2 = -(lcore1+17);	l3 = -4;			l4 = (lcore1+14);	Call fillSurface;
		l1 = (lcore1+7);	l2 = -(lcore1+16);	l3 = 3;				l4 = (lcore1+17);	Call fillSurface;
		
	ElseIf (itag == 2)
		x5 = Sqrt(2)*x_outlet/eta;
		y5 = h_peripheral/2 - ((x_outlet - x5) * (h_peripheral-h_cl)/2/x_outlet);	
		Point(newp) = {x5, y5, 0, 1.0};  Point(newp) = {x5, y5-h_bl, 0, 1.0}; 		Line(newl) = {pcore1  ,pcore1+1};
		Point(newp) = {x5, -y5, 0, 1.0}; Point(newp) = {x5, -(y5-h_bl), 0, 1.0}; 	Line(newl) = {pcore1+2,pcore1+3};
		Point(newp) = {x5, 0, 0, 1.0};		
		x6 = x5/2;
		y6 = h_peripheral/2 - ((x_outlet - x6) * (h_peripheral-h_cl)/2/x_outlet);
		Point(newp) = {x6, y6, 0, 1.0};  Point(newp) = {x6, y6-h_bl, 0, 1.0}; 		Line(newl) = {pcore1+5,pcore1+6};
		Point(newp) = {x6, -y6, 0, 1.0}; Point(newp) = {x6, -(y6-h_bl), 0, 1.0};  	Line(newl) = {pcore1+7,pcore1+8};
		Point(newp) = {x6, 0, 0, 1.0}; 
		Transfinite Curve {lcore1:lcore1+3}= n_bl Using Progression ratio_bl;
		Line(newl) = {pcore1+4,pcore1+1}; Line(newl) = {pcore1+4,pcore1+3};
		Line(newl) = {pcore1+9,pcore1+6}; Line(newl) = {pcore1+9,pcore1+8};
		Transfinite Curve {lcore1+4:lcore1+7}= n_curve Using Progression 1.0;
	Else
		x5 = x_outlet/eta/Cos(Pi/8);
		y5 = h_peripheral/2 - ((x_outlet - x5) * (h_peripheral-h_cl)/2/x_outlet);	
		Point(newp) = {x5, y5, 0, 1.0};  Point(newp) = {x5, y5-h_bl, 0, 1.0}; 		Line(newl) = {pcore1  ,pcore1+1};
		Point(newp) = {x5, -y5, 0, 1.0}; Point(newp) = {x5, -(y5-h_bl), 0, 1.0}; 	Line(newl) = {pcore1+2,pcore1+3};
		Point(newp) = {x5, 0, 0, 1.0};	
		Transfinite Curve {lcore1:lcore1+1}= n_bl Using Progression ratio_bl;
		Line(newl) = {pcore1+4,pcore1+1}; Line(newl) = {pcore1+4,pcore1+3};
		Transfinite Curve {lcore1+2:lcore1+3}= n_curve Using Progression 1.0;
	EndIf

	pcore2=newp; Printf("pcore2 =%g", pcore2);
Return

// Construct the core bulk
nwedge = 15;
islice = 0;
For i In {nwedge:0:-1}
	Call msfrCore; 
	If (pcore2 > pcore1)
		Rotate {{0,1,0}, {0,0,0}, i*Pi/8} { Point{pcore1:(pcore2-1)}; }
    EndIf
	Printf("islice =%g", islice);
	itag = islice%4;
	lref10 = newl; Printf("lref10 =%g", lref10);
	sref9=startSurface+1; Printf("sref9 =%g", sref9);
	If (itag == 0 && islice > 0)
		Line(newl) = {pcore1  ,pcore1-5}; 	Line(newl) = {pcore1+1,pcore1-4};
		Line(newl) = {pcore1+2,pcore1-3}; 	Line(newl) = {pcore1+3,pcore1-2};
		Line(newl) = {pcore1+4,pcore1-1};
		Line(newl) = {pcore1+5,pcore1-10}; 	Line(newl) = {pcore1+6,pcore1-9};
		Line(newl) = {pcore1+7,pcore1-8}; 	Line(newl) = {pcore1+8,pcore1-7};
		Line(newl) = {pcore1+9,pcore1-6};
		lref11 = newl; Printf("lref11 =%g", lref11);
		Transfinite Curve {lref10:lref11-1}= n_Azi Using Progression 1.0;

		l1 =  lref10;		l2 = lref10-32;		l3 = -(lref10+1);	l4 =-(lref10-18);	Call fillSurface;
		l1 =  lref10+1;		l2 =-(lref10-30);	l3 = -(lref10+4);	l4 = (lref10-14);	Call fillSurface;
		l1 =  lref10+2;		l2 = (lref10-31);	l3 = -(lref10+3);	l4 =-(lref10-17);	Call fillSurface;
		l1 =  lref10+3;		l2 =-(lref10-29);	l3 = -(lref10+4);	l4 = (lref10-13);	Call fillSurface;

		l1 =  lref10+5;		l2 = lref10-53;		l3 = -(lref10+6);	l4 =-(lref10-16);	Call fillSurface;
		l1 =  lref10+6;		l2 =-(lref10-49);	l3 = -(lref10+9);	l4 = (lref10-12);	Call fillSurface;
		l1 =  lref10+7;		l2 = (lref10-52);	l3 = -(lref10+8);	l4 =-(lref10-15);	Call fillSurface;
		l1 =  lref10+8;		l2 =-(lref10-48);	l3 = -(lref10+9);	l4 = (lref10-11);	Call fillSurface;

		l1 =  lref10;		l2 = lref10-28;		l3 =-(lref10+5);	l4 =-(lref10-10);	Call fillWallSurface;
		l1 =  lref10+1;		l2 = lref10-27;		l3 =-(lref10+6);	l4 =-(lref10-9);	Call fillSurface;
		l1 =  lref10+2;		l2 = lref10-26;		l3 =-(lref10+7);	l4 =-(lref10-8);	Call fillWallSurface;
		l1 =  lref10+3;		l2 = lref10-25;		l3 =-(lref10+8);	l4 =-(lref10-7);	Call fillSurface;
		l1 =  lref10+4;		l2 = lref10-24;		l3 =-(lref10+9);	l4 =-(lref10-6);	Call fillSurface;

		ldelta5 = 10; If (islice == 4) ldelta5=0; EndIf
		l1 =  lref10+5;		l2 = (lref10-37);		l3 =-(lref10-69-ldelta5);	l4 = (lref10-5);	Call fillWallSurface;
		l1 =  lref10+6;		l2 = (lref10-36);		l3 =-(lref10-68-ldelta5);	l4 = (lref10-4);	Call fillSurface;
		l1 =  lref10+7;		l2 = (lref10-35);		l3 =-(lref10-67-ldelta5);	l4 = (lref10-3);	Call fillWallSurface;
		l1 =  lref10+8;		l2 = (lref10-34);		l3 =-(lref10-66-ldelta5);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+9;		l2 = (lref10-33);		l3 =-(lref10-65-ldelta5);	l4 = (lref10-1);	Call fillSurface;

		s1=sref9;		s2=s1+4;		s3=s1-21;		s4=s1-8;		s5=s1+8;		s6=s1+9; 	Call fillVolume;
		s1=sref9+1;		s2=s1+4;		s3=s1-21;		s4=s1-5;		s5=s1+8;		s6=s1+11; 	Call fillVolume;
		s1=sref9+2;		s2=s1+4;		s3=s1-21;		s4=s1-9;		s5=s1+8;		s6=s1+9; 	Call fillVolume;
		s1=sref9+3;		s2=s1+4;		s3=s1-21;		s4=s1-6;		s5=s1+8;		s6=s1+9; 	Call fillVolume;

		sdelta4 = 0; If (islice == 4) sdelta4=18; EndIf
		s1=sref9+4;		s2=s1-70+sdelta4;		s3=s1-34;		s4=s1-10;		s5=s1+9;		s6=s1+10; 	Call fillVolume;
		s1=sref9+5;		s2=s1-67+sdelta4;		s3=s1-34;		s4=s1-7;		s5=s1+9;		s6=s1+12; 	Call fillVolume;
		s1=sref9+6;		s2=s1-71+sdelta4;		s3=s1-34;		s4=s1-11;		s5=s1+9;		s6=s1+10; 	Call fillVolume;
		s1=sref9+7;		s2=s1-68+sdelta4;		s3=s1-34;		s4=s1-8;		s5=s1+9;		s6=s1+10; 	Call fillVolume;
		
	ElseIf (itag == 1)
		Line(newl) = {pcore1  ,pcore1-10}; 	Line(newl) = {pcore1+1,pcore1-9};
		Line(newl) = {pcore1+2,pcore1-8}; 	Line(newl) = {pcore1+3,pcore1-7};
		Line(newl) = {pcore1+4,pcore1-6};
		lref11 = newl; Printf("lref11 =%g", lref11);
		Transfinite Curve {lref10:lref11-1}= n_Azi Using Progression 1.0;
		ldelta5 = 10; If (islice == 1) ldelta5=0; EndIf
		l1 =  lref10;		l2 = lref10-22-ldelta5;		l3 = -(lref10+1);	l4 =-(lref10-4);	Call fillSurface;
		l1 =  lref10+1;		l2 =-(lref10-18-ldelta5);	l3 = -(lref10+4);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+2;		l2 = (lref10-21-ldelta5);	l3 = -(lref10+3);	l4 =-(lref10-3);	Call fillSurface;
		l1 =  lref10+3;		l2 =-(lref10-17-ldelta5);	l3 = -(lref10+4);	l4 = (lref10-1);	Call fillSurface;			

	ElseIf (itag == 2)
		Line(newl) = {pcore1  ,pcore1-5}; 	Line(newl) = {pcore1+1,pcore1-4};
		Line(newl) = {pcore1+2,pcore1-3}; 	Line(newl) = {pcore1+3,pcore1-2};
		Line(newl) = {pcore1+4,pcore1-1};	
		Line(newl) = {pcore1+5,pcore1-5}; 	Line(newl) = {pcore1+6,pcore1-4};
		Line(newl) = {pcore1+7,pcore1-3}; 	Line(newl) = {pcore1+8,pcore1-2};
		Line(newl) = {pcore1+9,pcore1-1};
		Line(newl) = {pcore1+5,pcore1-10}; 	Line(newl) = {pcore1+6,pcore1-9};
		Line(newl) = {pcore1+7,pcore1-8}; 	Line(newl) = {pcore1+8,pcore1-7};
		Line(newl) = {pcore1+9,pcore1-6};
		lref11 = newl; Printf("lref11 =%g", lref11);
		Transfinite Curve {lref10:lref11-1}= n_Azi Using Progression 1.0;

		l1 =  lref10;		l2 = lref10-17;		l3 = -(lref10+1);	l4 =-(lref10-8);	Call fillSurface;
		l1 =  lref10+1;		l2 =-(lref10-15);	l3 = -(lref10+4);	l4 = (lref10-4);	Call fillSurface;
		l1 =  lref10+2;		l2 = (lref10-16);	l3 = -(lref10+3);	l4 =-(lref10-7);	Call fillSurface;
		l1 =  lref10+3;		l2 =-(lref10-14);	l3 = -(lref10+4);	l4 = (lref10-3);	Call fillSurface;		

		l1 =  lref10+5;		l2 = lref10-17;		l3 = -(lref10+6);	l4 =-(lref10-6);	Call fillSurface;
		l1 =  lref10+6;		l2 =-(lref10-15);	l3 = -(lref10+9);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+7;		l2 = (lref10-16);	l3 = -(lref10+8);	l4 =-(lref10-5);	Call fillSurface;
		l1 =  lref10+8;		l2 =-(lref10-14);	l3 = -(lref10+9);	l4 = (lref10-1);	Call fillSurface;

		ldelta5 = 10; If (islice == 2) ldelta5=0; EndIf
		l1 =  lref10+10;		l2 = lref10-33-ldelta5;		l3 = -(lref10+11);	l4 =-(lref10-6);	Call fillSurface;
		l1 =  lref10+11;		l2 =-(lref10-29-ldelta5);	l3 = -(lref10+14);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+12;		l2 = (lref10-32-ldelta5);	l3 = -(lref10+13);	l4 =-(lref10-5);	Call fillSurface;
		l1 =  lref10+13;		l2 =-(lref10-28-ldelta5);	l3 = -(lref10+14);	l4 = (lref10-1);	Call fillSurface;

		l1 =  lref10+5;		l2 = lref10-13;		l3 = (lref10-27-ldelta5);	l4 =-(lref10+10);	Call fillWallSurface;
		l1 =  lref10+6;		l2 = lref10-12;		l3 = (lref10-26-ldelta5);	l4 =-(lref10+11);	Call fillSurface;
		l1 =  lref10+7;		l2 = lref10-11;		l3 = (lref10-25-ldelta5);	l4 =-(lref10+12);	Call fillWallSurface;
		l1 =  lref10+8;		l2 = lref10-10;		l3 = (lref10-24-ldelta5);	l4 =-(lref10+13);	Call fillSurface;
		l1 =  lref10+9;		l2 = lref10-9;		l3 = (lref10-23-ldelta5);	l4 =-(lref10+14);	Call fillSurface;

		sdelta4 = 0; If (islice == 2) sdelta4=18; EndIf
		s1=sref9+4;		s2=s1-34+sdelta4;		s3=s1-8;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;
		s1=sref9+5;		s2=s1-31+sdelta4;		s3=s1-8;		s4=s1+4;		s5=s1+8;		s6=s1+11; 	Call fillVolume;
		s1=sref9+6;		s2=s1-35+sdelta4;		s3=s1-8;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;		
		s1=sref9+7;		s2=s1-32+sdelta4;		s3=s1-8;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;

	ElseIf (itag == 3)
		Line(newl) = {pcore1  ,pcore1-5}; 	Line(newl) = {pcore1+1,pcore1-4};
		Line(newl) = {pcore1+2,pcore1-3}; 	Line(newl) = {pcore1+3,pcore1-2};
		Line(newl) = {pcore1+4,pcore1-1};
		Line(newl) = {pcore1  ,pcore1-10}; 	Line(newl) = {pcore1+1,pcore1-9};
		Line(newl) = {pcore1+2,pcore1-8}; 	Line(newl) = {pcore1+3,pcore1-7};
		Line(newl) = {pcore1+4,pcore1-6};
		lref11 = newl; Printf("lref11 =%g", lref11);
		Transfinite Curve {lref10:lref11-1}= n_Azi Using Progression 1.0;		

		ldelta5 = 0; If (islice == 15) ldelta5=5; EndIf
		l1 =  lref10;		l2 = lref10-25-ldelta5;		l3 = -(lref10+1);	l4 =-(lref10-4);	Call fillSurface;
		l1 =  lref10+1;		l2 =-(lref10-21-ldelta5);	l3 = -(lref10+4);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+2;		l2 = (lref10-24-ldelta5);	l3 = -(lref10+3);	l4 =-(lref10-3);	Call fillSurface;
		l1 =  lref10+3;		l2 =-(lref10-20-ldelta5);	l3 = -(lref10+4);	l4 = (lref10-1);	Call fillSurface;		

		l1 =  lref10+5;		l2 = lref10-27-ldelta5;		l3 = -(lref10+6);	l4 =-(lref10-4);	Call fillSurface;
		l1 =  lref10+6;		l2 =-(lref10-23-ldelta5);	l3 = -(lref10+9);	l4 = (lref10-2);	Call fillSurface;
		l1 =  lref10+7;		l2 = (lref10-26-ldelta5);	l3 = -(lref10+8);	l4 =-(lref10-3);	Call fillSurface;
		l1 =  lref10+8;		l2 =-(lref10-22-ldelta5);	l3 = -(lref10+9);	l4 = (lref10-1);	Call fillSurface;

		l1 =  lref10+5;		l2 = lref10-19-ldelta5;		l3 =-(lref10-14-ldelta5);	l4 =-lref10;		Call fillWallSurface;
		l1 =  lref10+6;		l2 = lref10-18-ldelta5;		l3 =-(lref10-13-ldelta5);	l4 =-(lref10+1);	Call fillSurface;
		l1 =  lref10+7;		l2 = lref10-17-ldelta5;		l3 =-(lref10-12-ldelta5);	l4 =-(lref10+2);	Call fillWallSurface;
		l1 =  lref10+8;		l2 = lref10-16-ldelta5;		l3 =-(lref10-11-ldelta5);	l4 =-(lref10+3);	Call fillSurface;
		l1 =  lref10+9;		l2 = lref10-15-ldelta5;		l3 =-(lref10-10-ldelta5);	l4 =-(lref10+4);	Call fillSurface;

		sdelta4 = 0; If (islice == 15) sdelta4=9; EndIf
		s1=sref9;		s2=s1-17-sdelta4;		s3=s1-13-sdelta4;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;
		s1=sref9+1;		s2=s1-17-sdelta4;		s3=s1-13-sdelta4;		s4=s1+4;		s5=s1+8;		s6=s1+11; 	Call fillVolume;
		s1=sref9+2;		s2=s1-17-sdelta4;		s3=s1-13-sdelta4;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;
		s1=sref9+3;		s2=s1-17-sdelta4;		s3=s1-13-sdelta4;		s4=s1+4;		s5=s1+8;		s6=s1+9; 	Call fillVolume;

	EndIf
	islice = islice + 1; 

    If (islice == 15)
		Line(newl) = {pcore1+5,pcore1-100}; Line(newl) = {pcore1+6,pcore1-99};
		Line(newl) = {pcore1+7,pcore1-98 }; Line(newl) = {pcore1+8,pcore1-97};
		Line(newl) = {pcore1+9,pcore1-96 };
		lref12 = newl;
		Transfinite Curve {lref11:lref12-1}= n_Azi Using Progression 1.0;	

		l1 =-lref11;		l2 = lref11-21;		l3 =  (lref11+1);	l4 =-(lref11-270);	Call fillSurface;
		l1 =-(lref11+1);	l2 =-(lref11-17);	l3 =  (lref11+4);	l4 = (lref11-266);	Call fillSurface;
		l1 =-(lref11+2);	l2 = (lref11-20);	l3 =  (lref11+3);	l4 =-(lref11-269);	Call fillSurface;
		l1 =-(lref11+3);	l2 =-(lref11-16);	l3 =  (lref11+4);	l4 = (lref11-265);	Call fillSurface;

		l1 =-lref11;		l2 = lref11-5;		l3 =-(lref11-47);	l4 = (lref11-259);	Call fillWallSurface;
		l1 =-(lref11+1);	l2 = lref11-4;		l3 =-(lref11-46);	l4 = (lref11-258);	Call fillSurface;
		l1 =-(lref11+2);	l2 = lref11-3;		l3 =-(lref11-45);	l4 = (lref11-257);	Call fillWallSurface;
		l1 =-(lref11+3);	l2 = lref11-2;		l3 =-(lref11-44);	l4 = (lref11-256);	Call fillSurface;
		l1 =-(lref11+4);	l2 = lref11-1;		l3 =-(lref11-43);	l4 = (lref11-255);	Call fillSurface;

		s1=sref9+17;		s2=s1-45;		s3=s1-9;		s4=s1-207;		s5=s1+4;		s6=s1+5; 	Call fillVolume;
		s1=sref9+18;		s2=s1-42;		s3=s1-9;		s4=s1-204;		s5=s1+4;		s6=s1+7; 	Call fillVolume;
		s1=sref9+19;		s2=s1-46;		s3=s1-9;		s4=s1-208;		s5=s1+4;		s6=s1+5; 	Call fillVolume;
		s1=sref9+20;		s2=s1-43;		s3=s1-9;		s4=s1-205;		s5=s1+4;		s6=s1+5; 	Call fillVolume;


	ElseIf(islice == 16)
		Line(newl) = {pcore1  ,pcore1-115}; Line(newl) = {pcore1+1,pcore1-114};
		Line(newl) = {pcore1+2,pcore1-113}; Line(newl) = {pcore1+3,pcore1-112};
		Line(newl) = {pcore1+4,pcore1-111};
		lref12 = newl;
		Transfinite Curve {lref11:lref12-1}= n_Azi Using Progression 1.0;			

		l1 =-lref11;		l2 = lref11-14;		l3 =  (lref11+1);	l4 =-(lref11-291);	Call fillSurface;
		l1 =-(lref11+1);	l2 =-(lref11-12);	l3 =  (lref11+4);	l4 = (lref11-287);	Call fillSurface;
		l1 =-(lref11+2);	l2 = (lref11-13);	l3 =  (lref11+3);	l4 =-(lref11-290);	Call fillSurface;
		l1 =-(lref11+3);	l2 =-(lref11-11);	l3 =  (lref11+4);	l4 = (lref11-286);	Call fillSurface;
		
		l1 =-lref11;		l2 = lref11-10;		l3 = (lref11-19);	l4 =-(lref11-283);	Call fillWallSurface;
		l1 =-(lref11+1);	l2 = lref11-9;		l3 = (lref11-18);	l4 =-(lref11-282);	Call fillSurface;
		l1 =-(lref11+2);	l2 = lref11-8;		l3 = (lref11-17);	l4 =-(lref11-281);	Call fillWallSurface;
		l1 =-(lref11+3);	l2 = lref11-7;		l3 = (lref11-16);	l4 =-(lref11-280);	Call fillSurface;
		l1 =-(lref11+4);	l2 = lref11-6;		l3 = (lref11-15);	l4 =-(lref11-279);	Call fillSurface;

		s1=sref9;		s2=s1-218;		s3=s1-9;		s4=s1+13;		s5=s1+17;		s6=s1+18; 	Call fillVolume;
		s1=sref9+1;		s2=s1-215;		s3=s1-9;		s4=s1+13;		s5=s1+17;		s6=s1+20; 	Call fillVolume;
		s1=sref9+2;		s2=s1-219;		s3=s1-9;		s4=s1+13;		s5=s1+17;		s6=s1+18; 	Call fillVolume;
		s1=sref9+3;		s2=s1-216;		s3=s1-9;		s4=s1+13;		s5=s1+17;		s6=s1+18; 	Call fillVolume;

	EndIf
EndFor
prefcore = newp; Printf("prefcore =%g", prefcore-1);
lrefcore = newl;
srefcore = startSurface;

Printf("prefwall =%g; prefcore =%g", prefwall-1,prefcore-1);
Printf("lrefwall =%g; lrefcore =%g", lrefwall,lrefcore);
Printf("srefwall =%g; srefcore =%g", srefwall,srefcore);

nwedge=15;
// Connecting the peripheral and the core bulk regions
If (islice == 16)
	pdelta1 = 1;
	pdelta2 = 59;
	ldelta10 = 171;
	ldelta11 = 17;
	ldelta13 = 69;
	ldelta14 = 6;
	ifan = 0;
	sdelta2 = 16;
	sdelta3 = 107;

	For i In {nwedge:0:-1}
// Connecting the radial lines
		itag = i%2;
		lref13 = newl; Printf("lref13 =%g", lref13);
		Line(newl) = {prefcore-pdelta1,prefwall-pdelta2}; 
		Line(newl) = {prefcore-pdelta1-3,prefwall-pdelta2+1};
		Line(newl) = {prefcore-pdelta1-1,prefwall-pdelta2-1};
		Transfinite Curve {lref13:lref13+2}= n_width Using Progression 1.0;

		lref14 = newl; Printf("lref14 =%g", lref14);
		Line(newl) = {prefcore-pdelta1-4,prefwall-pdelta2+3};
		Line(newl) = {prefcore-pdelta1-3,prefwall-pdelta2+4}; 
		Line(newl) = {prefcore-pdelta1-2,prefwall-pdelta2+5};
		Line(newl) = {prefcore-pdelta1-1,prefwall-pdelta2+6}; 
		Transfinite Curve {lref14:lref14+3}= n_curve Using Progression 1.0;

// filling radial patches
		sref10=startSurface+1; 
		l1 =lref13;		l2 = (lrefwall-ldelta10);		l3 =-(lref13+1);			l4 =-(lrefcore-ldelta11);				Call fillSurface;
		l1 =lref13;		l2 =-(lrefwall-ldelta10-1);		l3 =-(lref13+2);			l4 =-(lrefcore-ldelta11+1);				Call fillSurface;
		ldelta12 = 0; If(itag == 0) ldelta12 = 2; EndIf
		l1 =lref13+1;	l2 = (lrefwall-ldelta10+1);		l3 =(lrefwall-ldelta10+9);	l4 =-(lref13+4);						Call fillSurface;
		l1 =lref13+4;	l2 =-(lrefwall-ldelta10+7);		l3 =-(lref13+3);			l4 = (lrefcore-ldelta11-2-ldelta12);	Call fillSurface;
		l1 =lref13+2;	l2 =-(lrefwall-ldelta10-2);		l3 =(lrefwall-ldelta10+10);	l4 =-(lref13+6);						Call fillSurface;
		l1 =lref13+5;	l2 = (lrefwall-ldelta10+8);		l3 =-(lref13+6);			l4 =-(lrefcore-ldelta11-1-ldelta12);	Call fillSurface;


		If(itag == 0) 	
			pdelta1 = pdelta1 + 5; 
		ElseIf(itag == 1)
			pdelta1 = pdelta1 + 10;
		EndIf

		jtag = i%4;
		If(jtag == 3)
			ldelta11 = ldelta11 + 21;
		ElseIf(jtag == 2)
			ldelta11 = ldelta11 + 11;
		ElseIf(jtag == 1)
			ldelta11 = ldelta11 + 26;
		Else
			ldelta11 = ldelta11 + 16;
		EndIf

		If(i == 15) 
			ldelta11 = ldelta11 + 5;
		ElseIf(i == 1)
			ldelta11 = ldelta11 - 10;
		EndIf

		If(i == 1)
			ldelta10 = ldelta10 + 101;
		Else
			ldelta10 = ldelta10 + 139;
		EndIf

		pdelta2 = pdelta2 + 67;
		Printf("ldelta10 =%g; ldelta11 =%g; ldelta12 =%g", ldelta10,ldelta11,ldelta12);
		ifan = ifan + 1; 
// filling horizental patches 
		If(ifan > 1)
			sref11=startSurface+1; 
			Printf("sref10 =%g; sref11 =%g", sref10,sref11);
			l1 =lref13;		l2 = (lrefwall-ldelta13);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14);				Call fillSurface;
			l1 =lref13+1;	l2 = (lrefwall-ldelta13+1);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-3);				Call fillSurface;
			l1 =lref13+2;	l2 = (lrefwall-ldelta13-1);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-1);				Call fillSurface;
			l1 =lref13+3;	l2 = (lrefwall-ldelta13+3);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-4);				Call fillWallSurface;
			l1 =lref13+4;	l2 = (lrefwall-ldelta13+4);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-3);				Call fillSurface;
			l1 =lref13+5;	l2 = (lrefwall-ldelta13+5);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-2);				Call fillWallSurface;
			l1 =lref13+6;	l2 = (lrefwall-ldelta13+6);		l3 =-(l1-7);			l4 = (lrefcore-ldelta14-1);				Call fillSurface;

// filling volumes 
			sdelta4 = 0; If(ifan > 2) sdelta4 = 7; EndIf
			s1=sref10;		s2=s1-6-sdelta4;	s3=sref11;				s4=s3+1;		    	s5=srefcore-sdelta2;	s6=srefwall-sdelta3; 	Call fillVolume;
			s1=sref10+2;	s2=s1-6-sdelta4;	s3=sref11+1;			s4=srefwall-sdelta3+3;	s5=srefwall-sdelta3+2;	s6=sref11+4; 			Call fillVolume;
			s1=sref10+3;	s2=s1-6-sdelta4;	s3=srefcore-sdelta2-1;	s4=srefwall-sdelta3+4;	s5=sref11+3;			s6=sref11+4; 			Call fillVolume;
			s1=sref10+1;	s2=s1-6-sdelta4;	s3=sref11;				s4=sref11+2;			s5=srefcore-sdelta2+2;	s6=srefwall-sdelta3-2; 	Call fillVolume;
			s1=sref10+4;	s2=s1-6-sdelta4;	s3=sref11+2;			s4=srefwall-sdelta3+5;	s5=srefwall-sdelta3-4;	s6=sref11+6; 			Call fillVolume;
			s1=sref10+5;	s2=s1-6-sdelta4;	s3=srefcore-sdelta2+1;	s4=srefwall-sdelta3+6;	s5=sref11+6;			s6=sref11+5; 			Call fillVolume;
			
			ldelta13 = ldelta13 + 139;

			jtag = i%4;
			If(jtag == 3)
				ldelta14 = ldelta14 + 23;
				sdelta2 = sdelta2 + 17; 
			ElseIf(jtag == 2)
				ldelta14 = ldelta14 + 24;
				sdelta2 = sdelta2 + 21;
			ElseIf(jtag == 1)
				ldelta14 = ldelta14 + 13;
				sdelta2 = sdelta2 + 4;
			Else
				ldelta14 = ldelta14 + 14;
				sdelta2 = sdelta2 + 18;
			EndIf

			If(i == 14) 
				ldelta14 = ldelta14 + 5;
				sdelta2 = sdelta2 + 9;
			ElseIf(i == 0)
				ldelta11 = ldelta11 + 17;
			EndIf

			sdelta3 = sdelta3 + 99;

			Printf("ldelta13 =%g; ldelta14 =%g; ifan =%g", ldelta13,ldelta14,ifan);

			If(ifan == 16)
				ldelta13 = 31; ldelta14 = 1;
				sref12=startSurface+1; Printf("sref12 =%g", sref12);
				l1 =lref13-105;		l2 =-(lrefwall-ldelta13);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14);				Call fillSurface;
				l1 =lref13-104;		l2 =-(lrefwall-ldelta13+1);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-3);				Call fillSurface;
				l1 =lref13-103;		l2 =-(lrefwall-ldelta13-1);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-1);				Call fillSurface;
				l1 =lref13-102;		l2 =-(lrefwall-ldelta13+3);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-4);				Call fillWallSurface;
				l1 =lref13-101;		l2 =-(lrefwall-ldelta13+4);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-3);				Call fillSurface;
				l1 =lref13-100;		l2 =-(lrefwall-ldelta13+5);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-2);				Call fillWallSurface;
				l1 =lref13- 99;		l2 =-(lrefwall-ldelta13+6);		l3 =-(l1+105);			l4 =-(lrefcore-ldelta14-1);				Call fillSurface;
// filling volumes 
				sdelta2 = 7; sdelta3 = 48;
				s1=sref10;		s2=s1-188;	s3=sref12;				s4=s3+1;		    	s5=srefcore-sdelta2;	s6=srefwall-sdelta3; 	Call fillVolume;
				s1=sref10+2;	s2=s1-188;	s3=sref12+1;			s4=srefwall-sdelta3+3;	s5=srefwall-sdelta3+2;	s6=sref12+4; 			Call fillVolume;
				s1=sref10+3;	s2=s1-188;	s3=srefcore-sdelta2-1;	s4=srefwall-sdelta3+4;	s5=sref12+3;			s6=sref12+4; 			Call fillVolume;
				s1=sref10+1;	s2=s1-188;	s3=sref12;				s4=sref12+2;			s5=srefcore-sdelta2+2;	s6=srefwall-sdelta3-2; 	Call fillVolume;
				s1=sref10+4;	s2=s1-188;	s3=sref12+2;			s4=srefwall-sdelta3+5;	s5=srefwall-sdelta3-4;	s6=sref12+6; 			Call fillVolume;
				s1=sref10+5;	s2=s1-188;	s3=srefcore-sdelta2+1;	s4=srefwall-sdelta3+6;	s5=sref12+6;			s6=sref12+5; 			Call fillVolume;
			EndIf
		EndIf
	EndFor
EndIf

Transfinite Surface "*"; 
Recombine Surface "*";
Physical Surface("Wall", 3) = wall[];
Physical Surface("Outlet", 2) = outlet[];
Physical Surface("Inlet", 1) = inlet[];
Physical Volume("Fluid", 4) = fluid[];
Transfinite Volume "*";//+
Hide "*";
//+
Show {
  Point{30}; Point{31}; Point{32}; Point{33}; Point{43}; Point{44}; Point{45}; Point{46}; Point{56}; Point{57}; Point{58}; Point{59}; Point{69}; Point{70}; Point{71}; Point{72}; Point{97}; Point{98}; Point{99}; Point{100}; Point{110}; Point{111}; Point{112}; Point{113}; Point{123}; Point{124}; Point{125}; Point{126}; Point{136}; Point{137}; Point{138}; Point{139}; Point{164}; Point{165}; Point{166}; Point{167}; Point{177}; Point{178}; Point{179}; Point{180}; Point{190}; Point{191}; Point{192}; Point{193}; Point{203}; Point{204}; Point{205}; Point{206}; Point{231}; Point{232}; Point{233}; Point{234}; Point{244}; Point{245}; Point{246}; Point{247}; Point{257}; Point{258}; Point{259}; Point{260}; Point{270}; Point{271}; Point{272}; Point{273}; Point{298}; Point{299}; Point{300}; Point{301}; Point{311}; Point{312}; Point{313}; Point{314}; Point{324}; Point{325}; Point{326}; Point{327}; Point{337}; Point{338}; Point{339}; Point{340}; Point{365}; Point{366}; Point{367}; Point{368}; Point{378}; Point{379}; Point{380}; Point{381}; Point{391}; Point{392}; Point{393}; Point{394}; Point{404}; Point{405}; Point{406}; Point{407}; Point{432}; Point{433}; Point{434}; Point{435}; Point{445}; Point{446}; Point{447}; Point{448}; Point{458}; Point{459}; Point{460}; Point{461}; Point{471}; Point{472}; Point{473}; Point{474}; Point{499}; Point{500}; Point{501}; Point{502}; Point{512}; Point{513}; Point{514}; Point{515}; Point{525}; Point{526}; Point{527}; Point{528}; Point{538}; Point{539}; Point{540}; Point{541}; Point{566}; Point{567}; Point{568}; Point{569}; Point{579}; Point{580}; Point{581}; Point{582}; Point{592}; Point{593}; Point{594}; Point{595}; Point{605}; Point{606}; Point{607}; Point{608}; Point{633}; Point{634}; Point{635}; Point{636}; Point{646}; Point{647}; Point{648}; Point{649}; Point{659}; Point{660}; Point{661}; Point{662}; Point{672}; Point{673}; Point{674}; Point{675}; Point{700}; Point{701}; Point{702}; Point{703}; Point{713}; Point{714}; Point{715}; Point{716}; Point{726}; Point{727}; Point{728}; Point{729}; Point{739}; Point{740}; Point{741}; Point{742}; Point{767}; Point{768}; Point{769}; Point{770}; Point{780}; Point{781}; Point{782}; Point{783}; Point{793}; Point{794}; Point{795}; Point{796}; Point{806}; Point{807}; Point{808}; Point{809}; Point{834}; Point{835}; Point{836}; Point{837}; Point{847}; Point{848}; Point{849}; Point{850}; Point{860}; Point{861}; Point{862}; Point{863}; Point{873}; Point{874}; Point{875}; Point{876}; Point{901}; Point{902}; Point{903}; Point{904}; Point{914}; Point{915}; Point{916}; Point{917}; Point{927}; Point{928}; Point{929}; Point{930}; Point{940}; Point{941}; Point{942}; Point{943}; Point{968}; Point{969}; Point{970}; Point{971}; Point{981}; Point{982}; Point{983}; Point{984}; Point{994}; Point{995}; Point{996}; Point{997}; Point{1007}; Point{1008}; Point{1009}; Point{1010}; Point{1035}; Point{1036}; Point{1037}; Point{1038}; Point{1048}; Point{1049}; Point{1050}; Point{1051}; Point{1061}; Point{1062}; Point{1063}; Point{1064}; Point{1074}; Point{1075}; Point{1076}; Point{1077}; Curve{26}; Curve{27}; Curve{32}; Curve{33}; Curve{36}; Curve{39}; Curve{68}; Curve{69}; Curve{74}; Curve{75}; Curve{78}; Curve{81}; Curve{127}; Curve{128}; Curve{133}; Curve{134}; Curve{137}; Curve{140}; Curve{169}; Curve{170}; Curve{175}; Curve{176}; Curve{179}; Curve{182}; Curve{229}; Curve{230}; Curve{231}; Curve{232}; Curve{241}; Curve{242}; Curve{243}; Curve{244}; Curve{266}; Curve{267}; Curve{272}; Curve{273}; Curve{276}; Curve{279}; Curve{308}; Curve{309}; Curve{314}; Curve{315}; Curve{318}; Curve{321}; Curve{368}; Curve{369}; Curve{370}; Curve{371}; Curve{380}; Curve{381}; Curve{382}; Curve{383}; Curve{405}; Curve{406}; Curve{411}; Curve{412}; Curve{415}; Curve{418}; Curve{447}; Curve{448}; Curve{453}; Curve{454}; Curve{457}; Curve{460}; Curve{507}; Curve{508}; Curve{509}; Curve{510}; Curve{519}; Curve{520}; Curve{521}; Curve{522}; Curve{544}; Curve{545}; Curve{550}; Curve{551}; Curve{554}; Curve{557}; Curve{586}; Curve{587}; Curve{592}; Curve{593}; Curve{596}; Curve{599}; Curve{646}; Curve{647}; Curve{648}; Curve{649}; Curve{658}; Curve{659}; Curve{660}; Curve{661}; Curve{683}; Curve{684}; Curve{689}; Curve{690}; Curve{693}; Curve{696}; Curve{725}; Curve{726}; Curve{731}; Curve{732}; Curve{735}; Curve{738}; Curve{785}; Curve{786}; Curve{787}; Curve{788}; Curve{797}; Curve{798}; Curve{799}; Curve{800}; Curve{822}; Curve{823}; Curve{828}; Curve{829}; Curve{832}; Curve{835}; Curve{864}; Curve{865}; Curve{870}; Curve{871}; Curve{874}; Curve{877}; Curve{924}; Curve{925}; Curve{926}; Curve{927}; Curve{936}; Curve{937}; Curve{938}; Curve{939}; Curve{961}; Curve{962}; Curve{967}; Curve{968}; Curve{971}; Curve{974}; Curve{1003}; Curve{1004}; Curve{1009}; Curve{1010}; Curve{1013}; Curve{1016}; Curve{1063}; Curve{1064}; Curve{1065}; Curve{1066}; Curve{1075}; Curve{1076}; Curve{1077}; Curve{1078}; Curve{1100}; Curve{1101}; Curve{1106}; Curve{1107}; Curve{1110}; Curve{1113}; Curve{1142}; Curve{1143}; Curve{1148}; Curve{1149}; Curve{1152}; Curve{1155}; Curve{1202}; Curve{1203}; Curve{1204}; Curve{1205}; Curve{1214}; Curve{1215}; Curve{1216}; Curve{1217}; Curve{1239}; Curve{1240}; Curve{1245}; Curve{1246}; Curve{1249}; Curve{1252}; Curve{1281}; Curve{1282}; Curve{1287}; Curve{1288}; Curve{1291}; Curve{1294}; Curve{1341}; Curve{1342}; Curve{1343}; Curve{1344}; Curve{1353}; Curve{1354}; Curve{1355}; Curve{1356}; Curve{1378}; Curve{1379}; Curve{1384}; Curve{1385}; Curve{1388}; Curve{1391}; Curve{1420}; Curve{1421}; Curve{1426}; Curve{1427}; Curve{1430}; Curve{1433}; Curve{1480}; Curve{1481}; Curve{1482}; Curve{1483}; Curve{1492}; Curve{1493}; Curve{1494}; Curve{1495}; Curve{1517}; Curve{1518}; Curve{1523}; Curve{1524}; Curve{1527}; Curve{1530}; Curve{1559}; Curve{1560}; Curve{1565}; Curve{1566}; Curve{1569}; Curve{1572}; Curve{1619}; Curve{1620}; Curve{1621}; Curve{1622}; Curve{1631}; Curve{1632}; Curve{1633}; Curve{1634}; Curve{1656}; Curve{1657}; Curve{1662}; Curve{1663}; Curve{1666}; Curve{1669}; Curve{1698}; Curve{1699}; Curve{1704}; Curve{1705}; Curve{1708}; Curve{1711}; Curve{1758}; Curve{1759}; Curve{1760}; Curve{1761}; Curve{1770}; Curve{1771}; Curve{1772}; Curve{1773}; Curve{1795}; Curve{1796}; Curve{1801}; Curve{1802}; Curve{1805}; Curve{1808}; Curve{1837}; Curve{1838}; Curve{1843}; Curve{1844}; Curve{1847}; Curve{1850}; Curve{1897}; Curve{1898}; Curve{1899}; Curve{1900}; Curve{1909}; Curve{1910}; Curve{1911}; Curve{1912}; Curve{1934}; Curve{1935}; Curve{1940}; Curve{1941}; Curve{1944}; Curve{1947}; Curve{1976}; Curve{1977}; Curve{1982}; Curve{1983}; Curve{1986}; Curve{1989}; Curve{2036}; Curve{2037}; Curve{2038}; Curve{2039}; Curve{2048}; Curve{2049}; Curve{2050}; Curve{2051}; Curve{2073}; Curve{2074}; Curve{2079}; Curve{2080}; Curve{2083}; Curve{2086}; Curve{2115}; Curve{2116}; Curve{2121}; Curve{2122}; Curve{2125}; Curve{2128}; Curve{2175}; Curve{2176}; Curve{2177}; Curve{2178}; Curve{2187}; Curve{2188}; Curve{2189}; Curve{2190}; Curve{2213}; Curve{2214}; Curve{2215}; Curve{2216}; Curve{2225}; Curve{2226}; Curve{2227}; Curve{2228}; Surface{112}; Surface{113}; Surface{114}; Surface{133}; Surface{134}; Surface{135}; Surface{211}; Surface{212}; Surface{213}; Surface{232}; Surface{233}; Surface{234}; Surface{310}; Surface{311}; Surface{312}; Surface{331}; Surface{332}; Surface{333}; Surface{409}; Surface{410}; Surface{411}; Surface{430}; Surface{431}; Surface{432}; Surface{508}; Surface{509}; Surface{510}; Surface{529}; Surface{530}; Surface{531}; Surface{607}; Surface{608}; Surface{609}; Surface{628}; Surface{629}; Surface{630}; Surface{706}; Surface{707}; Surface{708}; Surface{727}; Surface{728}; Surface{729}; Surface{805}; Surface{806}; Surface{807}; Surface{826}; Surface{827}; Surface{828}; Surface{904}; Surface{905}; Surface{906}; Surface{925}; Surface{926}; Surface{927}; Surface{1003}; Surface{1004}; Surface{1005}; Surface{1024}; Surface{1025}; Surface{1026}; Surface{1102}; Surface{1103}; Surface{1104}; Surface{1123}; Surface{1124}; Surface{1125}; Surface{1201}; Surface{1202}; Surface{1203}; Surface{1222}; Surface{1223}; Surface{1224}; Surface{1300}; Surface{1301}; Surface{1302}; Surface{1321}; Surface{1322}; Surface{1323}; Surface{1399}; Surface{1400}; Surface{1401}; Surface{1420}; Surface{1421}; Surface{1422}; Surface{1498}; Surface{1499}; Surface{1500}; Surface{1519}; Surface{1520}; Surface{1521}; Surface{1557}; Surface{1558}; Surface{1559}; Surface{1578}; Surface{1579}; Surface{1580}; 
}
