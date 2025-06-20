public class IconController {

	public String iconFileName;
	public String iconSvg;
	
	public void setIconFileName(String value){
		iconFileName = value;
		//System.debug('iconFileName (setter) is ' + iconFileName);
	}
	
	public String getIconFileName(){
		return iconFileName;
	}

	public String getIconSvg(){
		updateIconSvg();
		return iconSvg;
	}

	public void updateIconSvg(){
		//System.debug('iconName is ' + iconFileName);
		
		
		
						
		if(iconFileName == 'assignment'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						'width="33px" height="33px" viewBox="0 0 33 33" enable-background="new 0 0 33 33" xml:space="preserve"> ' +
					'<g> ' +
						'<g> ' +
							'<g opacity="0.15"> ' +
								'<path fill="#010101" d="M17,1L1,11h32L17,1z M26,13l1,2v12h4V15l1-2H26z M18,13l1,2v12h4V15l1-2H18z M10,13l1,2v12h4V15l1-2H10z ' +
									 'M2,13l1,2v12h4V15l1-2H2z M2,29l-1,4h32l-1-4H2z M19,7c0,1.105-0.895,2-2,2s-2-0.895-2-2c0-1.104,0.895-2,2-2S19,5.896,19,7z"/> ' +
							'</g> ' +
							'<g> ' +
								'<path fill="#BABCBE" d="M16,0L0,10h32L16,0z M25,12l1,2v12h4V14l1-2H25z M17,12l1,2v12h4V14l1-2H17z M9,12l1,2v12h4V14l1-2H9z ' +
									 'M1,12l1,2v12h4V14l1-2H1z M1,28l-1,4h32l-1-4H1z M18,6c0,1.105-0.895,2-2,2s-2-0.895-2-2c0-1.104,0.895-2,2-2S18,4.896,18,6z"/> ' +
							'</g> ' +
						'</g> ' +
					'</g> ' +
				'</svg>';
		}
		
		else if(iconFileName == 'roleTraining'){
			iconSvg = 
			'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" '+
	 		'width="45px" height="48px" viewBox="0 0 45 48" enable-background="new 0 0 45 48" xml:space="preserve">' +
			'<g>'+
			'<path fill="#FFFFFF" d="M40.498,0H4.501C2.024,0,0,2.023,0,4.502v38.996C0,45.977,2.024,48,4.501,48h35.997' +
			'C42.976,48,45,45.977,45,43.498V4.502C45,2.023,42.976,0,40.498,0z M39.001,41.998H5.999V6h33.002V41.998z M12.001,27H33v2.998' +
			'H12.001V27z M12.001,32.998H33V36H12.001V32.998z M15.001,13.5c0,2.482,2.016,4.498,4.498,4.498c2.486,0,4.501-2.016,4.501-4.498' +
			'c0-2.486-2.015-4.5-4.501-4.5C17.017,9,15.001,11.014,15.001,13.5z M22.501,17.998h-6c-2.476,0-4.5,1.354-4.5,3.002v3h15v-3' +
			'C27.001,19.352,24.977,17.998,22.501,17.998z"/>' +
			'</g>'+
			'</svg>';	
		}

		

		else if(iconFileName == 'cal'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="31px" height="33px" viewBox="0 0 31 33" enable-background="new 0 0 31 33" xml:space="preserve"> ' +
					'<g> ' +
						'<g opacity="0.15"> ' +
							'<path d="M11,13h4v4h-4V13z M17,13h4v4h-4V13z M23,13h4v4h-4V13z M5,25h4v4H5V25z M11,25h4v4h-4V25z M17,25h4v4h-4V25z M11,19h4v4 ' +
								'h-4V19z M17,19h4v4h-4V19z M23,19h4v4h-4V19z M5,19h4v4H5V19z M27,1v2h-4V1H9v2H5V1H1v32h30V1H27z M29,31H3V9h26V31z"/> ' +
						'</g> ' +
						'<g> ' +
							'<path fill="#FFFFFF" d="M10,12h4v4h-4V12z M16,12h4v4h-4V12z M22,12h4v4h-4V12z M4,24h4v4H4V24z M10,24h4v4h-4V24z M16,24h4v4h-4 ' +
								'V24z M10,18h4v4h-4V18z M16,18h4v4h-4V18z M22,18h4v4h-4V18z M4,18h4v4H4V18z M26,0v2h-4V0H8v2H4V0H0v32h30V0H26z M28,30H2V8h26 ' +
								'V30z"/> ' +
						'</g> ' +
					'</g> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'check-circle'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="75.182px" height="75.182px" viewBox="0 0 75.182 75.182" enable-background="new 0 0 75.182 75.182" xml:space="preserve"> ' +
					'<path fill="#648C1A" d="M37.592,0C16.83,0,0,16.829,0,37.591s16.83,37.591,37.592,37.591s37.59-16.829,37.59-37.591 ' +
						'S58.354,0,37.592,0z M30.543,61.085L14.979,40.821l6.9-7.195l8.666,11.013l27.168-22.172l3.377,3.377L30.543,61.085z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'check'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="20px" height="15.625px" viewBox="0 0 20 15.625" enable-background="new 0 0 20 15.625" xml:space="preserve"> ' +
					'<path fill="#3C61A1" d="M16.875,0L7.5,9.375L3.125,5L0,8.125l7.5,7.5L20,3.125L16.875,0z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'close'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="15px" height="15px" viewBox="0 0 15 15" enable-background="new 0 0 15 15" xml:space="preserve"> ' +
					'<path fill="#F15B5C" d="M14.863,12.051L14.863,12.051L10.312,7.5l4.551-4.551l0,0c0.049-0.049,0.084-0.106,0.107-0.167 ' +
						'c0.062-0.167,0.026-0.361-0.107-0.496l-2.15-2.149c-0.134-0.134-0.329-0.169-0.495-0.108c-0.062,0.022-0.118,0.059-0.167,0.108l0,0 ' +
						'L7.5,4.687l-4.55-4.55l0,0C2.9,0.088,2.844,0.053,2.781,0.03C2.615-0.032,2.422,0.004,2.287,0.138L0.138,2.286 ' +
						'c-0.135,0.135-0.17,0.33-0.108,0.496C0.053,2.843,0.088,2.9,0.138,2.949l0,0L4.688,7.5l-4.55,4.551l0,0 ' +
						'c-0.05,0.049-0.085,0.105-0.108,0.168c-0.062,0.165-0.026,0.359,0.108,0.494l2.149,2.149c0.135,0.134,0.329,0.171,0.494,0.108 ' +
						'c0.062-0.023,0.119-0.059,0.169-0.108l0,0l4.55-4.55l4.551,4.55l0,0c0.049,0.05,0.105,0.085,0.167,0.108 ' +
						'c0.167,0.062,0.361,0.025,0.495-0.108l2.15-2.149c0.134-0.135,0.17-0.329,0.107-0.494C14.947,12.156,14.912,12.1,14.863,12.051z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'downArrow'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="12.989px" height="7.341px" viewBox="0 0 12.989 7.341" enable-background="new 0 0 12.989 7.341" xml:space="preserve"> ' +
					'<path fill="#4B74B9" d="M1.667,0.283c-0.381-0.377-1-0.377-1.381,0c-0.381,0.378-0.381,0.99,0,1.368l5.518,5.407 ' +
						'c0.381,0.378,1,0.378,1.383,0l5.518-5.407c0.381-0.378,0.381-0.99,0-1.368c-0.383-0.377-1-0.377-1.383-0.001L6.495,4.717 ' +
						'L1.667,0.283z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'globe'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="20px" height="20.001px" viewBox="0 0 20 20.001" enable-background="new 0 0 20 20.001" xml:space="preserve"> ' +
					'<path fill="#CCCCCC" d="M10.002,0C4.486,0,0,4.487,0,10c0,5.515,4.486,10.001,10.002,10.001S20,15.515,20,10 ' +
						'C20,4.487,15.518,0,10.002,0z M18.527,10c0,1.95-0.661,3.75-1.763,5.19c-0.313-0.246-0.646-0.905-0.332-1.59 ' +
						'c0.313-0.687,0.395-2.277,0.324-2.897c-0.067-0.619-0.391-2.111-1.264-2.124c-0.874-0.014-1.473-0.303-1.99-1.338 ' +
						'c-1.078-2.153,2.019-2.567,0.94-3.76c-0.299-0.335-1.855,1.378-2.085-0.906C12.346,2.414,12.5,2.17,12.709,1.916 ' +
						'C16.087,3.052,18.527,6.245,18.527,10z M8.828,1.557C8.623,1.953,8.088,2.114,7.76,2.413C7.046,3.057,6.742,2.969,6.357,3.588 ' +
						'C5.97,4.205,4.725,5.098,4.725,5.544c0,0.447,0.63,0.976,0.945,0.873C5.985,6.313,6.812,6.319,7.302,6.49 ' +
						'c0.487,0.174,4.076,0.346,2.935,3.379c-0.363,0.966-1.952,0.803-2.375,2.401c-0.062,0.232-0.284,1.235-0.297,1.562 ' +
						'c-0.027,0.506,0.355,2.414-0.133,2.414s-1.809-1.707-1.809-2.016c0-0.31-0.341-1.395-0.341-2.323S3.701,10.993,3.701,9.76 ' +
						'c0-1.115,0.859-1.669,0.664-2.203c-0.188-0.53-1.696-0.55-2.324-0.614C3.138,4.097,5.718,1.986,8.828,1.557z M7.318,18.094 ' +
						'c0.512-0.271,0.562-0.619,1.03-0.638c0.528-0.025,0.96-0.208,1.562-0.341c0.53-0.116,1.482-0.655,2.319-0.724 ' +
						'c0.706-0.059,2.097,0.037,2.473,0.718c-1.349,0.896-2.966,1.42-4.7,1.42C9.064,18.529,8.162,18.374,7.318,18.094z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'leftArrow'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="16.25px" height="16.25px" viewBox="0 0 16.25 16.25" enable-background="new 0 0 16.25 16.25" xml:space="preserve"> ' +
					'<g> ' +
						'<circle fill="#C9CBCB" cx="8.125" cy="8.125" r="8.125"/> ' +
						'<g> ' +
							'<path fill="#FBFAF9" d="M8.688,4.266c0.27,0,0.539,0.109,0.736,0.325c0.373,0.407,0.346,1.04-0.062,1.412L7.044,8.125l2.318,2.122 ' +
								'c0.408,0.372,0.436,1.005,0.062,1.412c-0.373,0.408-1.006,0.436-1.412,0.062L4.888,8.862C4.681,8.673,4.562,8.405,4.562,8.125 ' +
								's0.118-0.548,0.325-0.737l3.125-2.859C8.204,4.353,8.446,4.266,8.688,4.266z"/> ' +
						'</g> ' +
					'</g> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'link-arrow'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="10.885px" height="10.887px" viewBox="0 0 10.885 10.887" enable-background="new 0 0 10.885 10.887" xml:space="preserve"> ' +
					'<path fill="#FFFFFF" d="M5.442,0C2.437,0,0,2.438,0,5.443s2.437,5.443,5.442,5.443s5.442-2.438,5.442-5.443S8.448,0,5.442,0z ' +
						 'M7.932,5.815L5.022,8.784c-0.204,0.205-0.533,0.205-0.736,0c-0.202-0.205-0.202-0.538,0-0.743l2.386-2.598L4.285,2.847 ' +
						'C4.084,2.641,4.084,2.309,4.286,2.103c0.203-0.205,0.532-0.205,0.736,0l2.909,2.969C8.135,5.277,8.135,5.61,7.932,5.815z"/> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'mail'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="93.6px" height="73.125px" ' + 
					'viewBox="0 0 93.6 73.125" enable-background="new 0 0 93.6 73.125" xml:space="preserve"> ' +
					'<path fill="#104C8B" d="M84.825,0H8.775C3.947,0,0,3.796,0,8.438v56.25c0,4.642,3.947,8.438,8.775,8.438h76.05c4.827,0,8.774-3.796,8.774-8.438V8.438C93.6, ' +
					'3.796,89.652,0,84.825,0z M36.449,37.123l-24.75,18.536V11.568L36.449,37.123zM16.122,11.25h61.355L46.8,33.398L16.122,11.25z M37.41,38.117l9.39,9.695l9.39-9.695l19.246, ' +
					'23.758H18.164L37.41,38.117zM57.15,37.123L81.9,11.568v44.088L57.15,37.123z"/> ' +
					'</svg> ';
		}
		
		
				
		else if(iconFileName == 'magnifying-glass'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="25px" height="25px" viewBox="0 0 25 25" enable-background="new 0 0 25 25" xml:space="preserve"> ' +
					'<g> ' +
						'<g> ' +
							'<path fill="#17B5EA" d="M24.438,21.149l-5.979-5.978c0.902-1.482,1.421-3.223,1.421-5.083C19.88,4.684,15.195,0,9.787,0 ' +
								'C4.381,0,0,4.382,0,9.787c0,5.408,4.685,10.091,10.091,10.091c1.797,0,3.48-0.485,4.927-1.331l6.013,6.012 ' +
								'c0.588,0.588,1.542,0.588,2.13,0l1.492-1.492C25.239,22.479,25.026,21.738,24.438,21.149z M3.014,9.787 ' +
								'c0-3.742,3.032-6.775,6.773-6.775c3.744,0,7.079,3.334,7.079,7.077s-3.033,6.778-6.775,6.778S3.014,13.531,3.014,9.787z"/> ' +
						'</g> ' +
					'</g> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'person-plus'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
						 'width="25.268px" height="22.74px" viewBox="0 0 25.268 22.74" enable-background="new 0 0 25.268 22.74" xml:space="preserve"> ' +
					'<g> ' +
						'<g> ' +
							'<path fill="#17B5EA" d="M15.637,16.99c-3.146-1.136-4.152-2.093-4.152-4.143c0-1.231,0.961-0.829,1.383-3.083 ' +
								'c0.174-0.936,1.023-0.016,1.186-2.15c0-0.85-0.463-1.062-0.463-1.062s0.234-1.259,0.326-2.228C14.031,3.118,13.213,0,8.844,0 ' +
								'C4.477,0,3.656,3.118,3.77,4.325c0.094,0.969,0.328,2.228,0.328,2.228S3.635,6.765,3.635,7.614 ' +
								'c0.162,2.135,1.012,1.215,1.186,2.15c0.424,2.254,1.385,1.852,1.385,3.083c0,2.05-1.006,3.007-4.154,4.143 ' +
								'C1.672,17.126,0.768,17.339,0,17.67v5.07h20.215c0,0,0-1.868,0-2.659C20.215,19.289,18.795,18.128,15.637,16.99z M21.479,10.106 ' +
								'V6.317h-2.527v3.789H15.16v2.527h3.791v3.789h2.527v-3.789h3.789v-2.527H21.479z"/> ' +
						'</g> ' +
					'</g> ' +
				'</svg>';
		}
		
		
		
		else if(iconFileName == 'training'){
			iconSvg = 
				'<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" ' +
							 'width="48px" height="38px" viewBox="0 0 48 38" enable-background="new 0 0 48 38" xml:space="preserve"> ' +
						'<g opacity="0.5"> ' +
							'<rect x="4.37" y="10.131" fill="#BABCBE" width="32.635" height="24.469"/> ' +
							'<rect x="38.711" y="10.131" fill="#BABCBE" width="6.078" height="24.469"/> ' +
							'<polygon fill="#BABCBE" points="14.288,10.131 14.288,3.092 30.924,3.092 30.924,10.131 29.005,10.131 29.005,5.012 16.207,5.012 16.207,10.131 	"/> ' +
							'<rect x="11.397" y="10.131" fill="#BABCBE" width="2.891" height="4.693"/> ' +
							'<rect x="26.168" y="10.131" fill="#BABCBE" width="2.825" height="4.713"/> ' +
							'<rect x="11.883" y="13.211" fill="#BABCBE" width="1.919" height="1.319"/> ' +
							'<rect x="26.622" y="13.211" fill="#BABCBE" width="1.921" height="1.319"/> ' +
						'</g> ' +
						'<g> ' +
							'<rect x="3.523" y="8.805" fill="#BABCBE" width="32.637" height="24.469"/> ' +
							'<rect x="37.866" y="8.805" fill="#BABCBE" width="6.078" height="24.469"/> ' +
							'<polygon fill="#BABCBE" points="13.443,8.805 13.443,1.766 30.079,1.766 30.079,8.805 28.161,8.805 28.161,3.686 15.362,3.686 15.362,8.805 	"/> ' +
							'<rect x="10.553" y="8.458" fill="#FFFFFF" width="2.891" height="5.038"/> ' +
							'<rect x="25.322" y="8.458" fill="#FFFFFF" width="2.828" height="5.059"/> ' +
							'<rect x="11.036" y="11.884" fill="#BABCBE" width="1.921" height="1.32"/> ' +
							'<rect x="25.777" y="11.884" fill="#BABCBE" width="1.919" height="1.32"/> ' +
						'</g> ' +
				'</svg>';
		}


				
		else{
			iconSvg = null;
		}
	}

	
}