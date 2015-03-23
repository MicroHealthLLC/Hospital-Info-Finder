package com.micro.health.hospital.finder;

import java.util.List;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;
import com.micro.health.hospital.finder.database.HospitalFinderDBAdapter;
import com.micro.health.hospital.finder.dto.TermDTO;

public class HospitalDetailActivity extends MapActivity  implements View.OnClickListener {
	private Button back;
	private ImageButton favBtn;
	
	private MapView imageMap;
	private TextView hospitalName;
	private TextView phone;
	private TextView homepage;
	private TextView address;
	private TextView directionstohere;
	
	private ProgressBar proBarhowPatientsRatedHighest;
	private ProgressBar proBarhowPatientsRatedLow;
	private TextView howPatientsRatedHighest;
	private TextView howPatientsRatedLow;
	
	private ProgressBar proBarhowPatientsRecommendDefinitely;
	private ProgressBar proBarhowPatientsRecommendProbably;
	private TextView howPatientsRecommendDefinitely;
	private TextView howPatientsRecommendProbably;
	
	private TextView seecomplete;
	private TextView pssr;
	
	private LinearLayout pssrll;
	
	private ProgressBar proBarhowNursesAlways;
	private ProgressBar proBarhowNursesSometimes;
	private TextView howNursesAlways;
	private TextView howNursesSometimes;
	
	private ProgressBar proBarhowDoctorsAlways;
	private ProgressBar proBarhowDoctorsSometimes;
	private TextView howDoctorsAlways;
	private TextView howDoctorsSometimes;
	
	private ProgressBar proBarhowHelpAlways;
	private ProgressBar proBarhowHelpSometimes;
	private TextView howHelpAlways;
	private TextView howHelpSometimes;
	
	private ProgressBar proBarhowWellControlledAlways;
	private ProgressBar proBarhowWellControlledSometimes;
	private TextView howWellControlledAlways;
	private TextView howWellControlledSometimes;
	
	private ProgressBar proBarhowMedicinesAlways;
	private ProgressBar proBarhowMedicinesSometimes;
	private TextView howMedicinesAlways;
	private TextView howMedicinesSometimes;
	
	private ProgressBar proBarhowCleanAlways;
	private ProgressBar proBarhowCleanSometimes;
	private TextView howCleanAlways;
	private TextView howCleanSometimes;
	
	private ProgressBar proBarhowQuietAlways;
	private ProgressBar proBarhowQuietSometimes;
	private TextView howQuietAlways;
	private TextView howQuietSometimes;
	
	private ProgressBar proBarhowRecoveryAlways;
	private ProgressBar proBarhowRecoverySometimes;
	private TextView howRecoveryAlways;
	private TextView howRecoverySometimes;
	
	private TextView completedsurveys;
	private ProgressBar proBarsurveyresponserate;
	private TextView surveyresponserate;
	
	private TextView hospitalFootNote;
	private LinearLayout hospitalFootNoteLL;
	
	private int id;
	private TermDTO hospitalData;
	
	List<Overlay> mapOverlays;
	MyItemizedOverlay itemizedOverlay;

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.hospitalinfo);
        

        
        Bundle bn = getIntent().getExtras();
        if(bn!=null)
        {
        	if(bn.containsKey(HospitalApplication.ID))
        		id = bn.getInt(HospitalApplication.ID);
        }
        
        HospitalFinderDBAdapter sharedDB = new HospitalFinderDBAdapter(HospitalDetailActivity.this);
        sharedDB.open();
        hospitalData = sharedDB.getHospitalById(id);
        sharedDB.close();
        
        if(hospitalData == null)
        	onBackPressed();
        
        back = (Button) findViewById(R.id.back);
    	favBtn = (ImageButton) findViewById(R.id.starbtn);
    	
    	imageMap = (MapView) findViewById(R.id.hospitalMap);
    	hospitalName = (TextView) findViewById(R.id.hospitalName);
    	phone = (TextView) findViewById(R.id.phonenumber);
    	
    	homepage = (TextView) findViewById(R.id.homepage);
    	address = (TextView) findViewById(R.id.address);
    	directionstohere = (TextView) findViewById(R.id.directionstohere);
    	
    	proBarhowPatientsRatedHighest = (ProgressBar) findViewById(R.id.proBarpatientsratedhighest);
    	proBarhowPatientsRatedLow = (ProgressBar) findViewById(R.id.probarpatientsratedlow);
    	howPatientsRatedHighest = (TextView) findViewById(R.id.patientsratedhighest);
    	howPatientsRatedLow = (TextView) findViewById(R.id.patientsratedlow);
    	
    	proBarhowPatientsRecommendDefinitely = (ProgressBar) findViewById(R.id.proBarpatientsrecommenddefinitely);
    	proBarhowPatientsRecommendProbably = (ProgressBar) findViewById(R.id.proBarpatientsrecommendprobably);
    	howPatientsRecommendDefinitely = (TextView) findViewById(R.id.patientsrecommenddefinitely);
    	howPatientsRecommendProbably = (TextView) findViewById(R.id.patientsrecommendprobably);
    	
    	seecomplete = (TextView) findViewById(R.id.seecomplete);
    	pssr = (TextView) findViewById(R.id.pssr);
    	
    	pssrll = (LinearLayout) findViewById(R.id.seecompletedetails);
    	
    	proBarhowNursesAlways = (ProgressBar) findViewById(R.id.proBarnursesalways);
    	proBarhowNursesSometimes = (ProgressBar) findViewById(R.id.proBarhownursessometimesornever);
    	howNursesAlways = (TextView) findViewById(R.id.nursesalways);
    	howNursesSometimes = (TextView) findViewById(R.id.hownursessometimesornever);
    	
    	proBarhowDoctorsAlways = (ProgressBar) findViewById(R.id.proBarhowdoctorsalways);
    	proBarhowDoctorsSometimes = (ProgressBar) findViewById(R.id.proBarhowdoctorssometimesornever);
    	howDoctorsAlways = (TextView) findViewById(R.id.howdoctorsalways);
    	howDoctorsSometimes = (TextView) findViewById(R.id.howdoctorssometimesornever);
    	
    	proBarhowHelpAlways = (ProgressBar) findViewById(R.id.proBarhowhelpalways);
    	proBarhowHelpSometimes = (ProgressBar) findViewById(R.id.proBarhowhelpsometimesornever);
    	howHelpAlways = (TextView) findViewById(R.id.howhelpalways);
    	howHelpSometimes = (TextView) findViewById(R.id.howhelpsometimesornever);
    	
    	proBarhowWellControlledAlways = (ProgressBar) findViewById(R.id.proBarhowwellcontrolledalways);
    	proBarhowWellControlledSometimes = (ProgressBar) findViewById(R.id.proBarhowwellcontrolledsometimesornever);
    	howWellControlledAlways = (TextView) findViewById(R.id.howwellcontrolledalways);
    	howWellControlledSometimes = (TextView) findViewById(R.id.howwellcontrolledsometimesornever);
    	
    	proBarhowMedicinesAlways = (ProgressBar) findViewById(R.id.proBarhowmedicinesalways);
    	proBarhowMedicinesSometimes = (ProgressBar) findViewById(R.id.proBarhowmedicinessometimesornever);
    	howMedicinesAlways = (TextView) findViewById(R.id.howmedicinesalways);
    	howMedicinesSometimes = (TextView) findViewById(R.id.howmedicinessometimesornever);
    	
    	proBarhowCleanAlways = (ProgressBar) findViewById(R.id.proBarhowbathroomsalways);
    	proBarhowCleanSometimes = (ProgressBar) findViewById(R.id.proBarhowbathroomssometimesornever);
    	howCleanAlways = (TextView) findViewById(R.id.howbathroomsalways);
    	howCleanSometimes = (TextView) findViewById(R.id.howbathroomssometimesornever);
    	
    	proBarhowQuietAlways = (ProgressBar) findViewById(R.id.proBarhowquietalways);
    	proBarhowQuietSometimes = (ProgressBar) findViewById(R.id.proBarhowquietsometimesornever);
    	howQuietAlways = (TextView) findViewById(R.id.howquietalways);
    	howQuietSometimes = (TextView) findViewById(R.id.howquietsometimesornever);
    	
    	proBarhowRecoveryAlways = (ProgressBar) findViewById(R.id.proBarhowrecoveryalways);
    	proBarhowRecoverySometimes = (ProgressBar) findViewById(R.id.proBarhowrecoverysometimesornever);
    	howRecoveryAlways = (TextView) findViewById(R.id.howrecoveryalways);
    	howRecoverySometimes = (TextView) findViewById(R.id.howrecoverysometimesornever);
    	
    	completedsurveys = (TextView) findViewById(R.id.completedsurveys);
    	proBarsurveyresponserate = (ProgressBar) findViewById(R.id.proBarsurveyresponserate);
    	surveyresponserate = (TextView) findViewById(R.id.surveyresponserate);
    	
    	hospitalFootNoteLL = (LinearLayout) findViewById(R.id.hospitalfootnoteLL);
    	hospitalFootNote = (TextView) findViewById(R.id.hospitalfootnote);
    	
    	back.setOnClickListener(this);
    	favBtn.setOnClickListener(this);
    	pssr.setOnClickListener(this);
    	directionstohere.setOnClickListener(this);
    	phone.setOnClickListener(this);
    	
    	mapOverlays = imageMap.getOverlays();
		
		itemizedOverlay = new MyItemizedOverlay(getResources().getDrawable(R.drawable.pin), imageMap);
		GeoPoint point = new GeoPoint((int)(hospitalData.getLatitude()*1E6),(int)(hospitalData.getLongitude()*1E6));
		OverlayItem overlayItem = new OverlayItem(point, "",null);
		itemizedOverlay.addOverlay(overlayItem);
		mapOverlays.add(itemizedOverlay);
	    
    	imageMap.getController().animateTo(point);
    	imageMap.getController().setZoom(21);
    	
    	hospitalName.setText(hospitalData.getHopital_name());
    	phone.setText(hospitalData.getPhone_number());
    	homepage.setText(hospitalData.getHopital_name());
    	address.setText(Html.fromHtml(hospitalData.getAddress() + "<br/>" + hospitalData.getCity() + " " + hospitalData.getState() + " " + hospitalData.getZip_code() + "<br/>" + hospitalData.getCountry_name()));
    	
    	proBarhowPatientsRatedHighest.setProgress(hospitalData.getPercent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_());
    	proBarhowPatientsRatedLow.setProgress(hospitalData.getPercent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_());
    	howPatientsRatedHighest.setText(hospitalData.getPercent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_() + "%");
    	howPatientsRatedLow.setText(hospitalData.getPercent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_() +"%");
    	
    	proBarhowPatientsRecommendDefinitely.setProgress(hospitalData.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_());
    	proBarhowPatientsRecommendProbably.setProgress(hospitalData.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_());
    	howPatientsRecommendDefinitely.setText(hospitalData.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_() + "%");
    	howPatientsRecommendProbably.setText(hospitalData.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_() +"%");
    	
    	pssrll.setVisibility(View.GONE);
    	
    	proBarhowNursesAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_nurses_always_communicated_well_());
    	proBarhowNursesSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_());
    	howNursesAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_their_nurses_always_communicated_well_()+ "%");
    	howNursesSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_() +"%");
    	
    	proBarhowDoctorsAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_doctors_always_communicated_well_());
    	proBarhowDoctorsSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_());
    	howDoctorsAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_their_doctors_always_communicated_well_() + "%");
    	howDoctorsSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_() + "%");
    	
    	proBarhowHelpAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_());
    	proBarhowHelpSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_());
    	howHelpAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_() + "%");
    	howHelpSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_() +"%");
    	
    	proBarhowWellControlledAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_pain_was_always_well_controlled_());
    	proBarhowWellControlledSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_());
    	howWellControlledAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_their_pain_was_always_well_controlled_() +"%");
    	howWellControlledSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_() + "%");
    	
    	proBarhowMedicinesAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_staff_always_explained_about_medicines_before_giving_it_to_them_());
    	proBarhowMedicinesSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_staff_sometimes_or_never_explained_about_medicines_before_giving_it_to_them_());
    	howMedicinesAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_staff_always_explained_about_medicines_before_giving_it_to_them_() + "%");
    	howMedicinesSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_staff_sometimes_or_never_explained_about_medicines_before_giving_it_to_them_() +"%");
    	
    	proBarhowCleanAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_());
    	proBarhowCleanSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_());
    	howCleanAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_() +"%");
    	howCleanSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_() +"%");
    	
    	proBarhowQuietAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_());
    	proBarhowQuietSometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_());
    	howQuietAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_() +"%");
    	howQuietSometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_() +"%");
    	
    	proBarhowRecoveryAlways.setProgress(hospitalData.getPercent_of_patients_who_reported_that_yes_they_were_given_information_about_what_to_do_during_their_recovery_at_home_());
    	proBarhowRecoverySometimes.setProgress(hospitalData.getPercent_of_patients_who_reported_that_they_were_not_given_information_about_what_to_do_during_their_recovery_at_home_());
    	howRecoveryAlways.setText(hospitalData.getPercent_of_patients_who_reported_that_yes_they_were_given_information_about_what_to_do_during_their_recovery_at_home_() + "%");
    	howRecoverySometimes.setText(hospitalData.getPercent_of_patients_who_reported_that_they_were_not_given_information_about_what_to_do_during_their_recovery_at_home_() +"%");
    	
    	completedsurveys.setText(hospitalData.getNumber_of_completed_surveys());
    	proBarsurveyresponserate.setProgress(hospitalData.getSurvey_response_rate_percent());
    	surveyresponserate.setText(hospitalData.getSurvey_response_rate_percent()+"%");
    	
    	if(hospitalData.getHospitalNote() != null) {
    		if(!hospitalData.getHospitalNote().equals("")) {
    			hospitalFootNote.setText("*" + hospitalData.getHospitalNote());
    			hospitalFootNoteLL.setVisibility(View.VISIBLE);
    		} else {
    			hospitalFootNoteLL.setVisibility(View.GONE);
    			hospitalFootNote.setText("");
    		}
    	} else {
			hospitalFootNoteLL.setVisibility(View.GONE);
			hospitalFootNote.setText("");
		}
    	
    	favBtn.setSelected(hospitalData.isFavorites());
    }

	@Override
	public void onClick(View v) {
		switch(v.getId())
		{
			case R.id.back:
				onBackPressed();
				break;
			case R.id.starbtn:
				hospitalData.setFavorites(!hospitalData.isFavorites());
				favBtn.setSelected(hospitalData.isFavorites());
				HospitalFinderDBAdapter mydb = new HospitalFinderDBAdapter(HospitalDetailActivity.this);
				mydb.open();
				mydb.updateFavorite(hospitalData.getId(), hospitalData.isFavorites()?1:0);
				mydb.close();
				break;
			case R.id.pssr:
				if(pssrll.getVisibility() == View.VISIBLE) {
					pssrll.setVisibility(View.GONE);
					seecomplete.setText(getString(R.string.seecomplete));
				} else {
					pssrll.setVisibility(View.VISIBLE);
					seecomplete.setText(getString(R.string.hidecomplete));
				}
				break;
			case R.id.directionstohere:
				double lat = 0.0;
				double longi = 0.0;
				if(HospitalApplication.getCurrentLocation() !=null) {
					lat = HospitalApplication.getCurrentLocation() .getLatitude();
					longi = HospitalApplication.getCurrentLocation() .getLongitude();
				}
				String url = "http://maps.google.com/maps?saddr="+ lat +"," + longi +"&daddr=" + hospitalData.getLatitude() +"," + hospitalData.getLongitude();
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
				startActivity(browserIntent);
				break;
			case R.id.phonenumber:
				Intent callIntent = new Intent(Intent.ACTION_CALL);
				callIntent.setData(Uri.parse("tel:" + phone.getText().toString()));
				startActivity(callIntent);
				break;
		}
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT)
				&& keyCode == KeyEvent.KEYCODE_BACK
				&& event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		finish();
	}


	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
	}
}