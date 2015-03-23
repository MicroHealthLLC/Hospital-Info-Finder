package com.micro.health.hospital.finder;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.ExpandableListView;
import android.widget.ImageView;
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

public class HospitalFinderActivity extends MapActivity implements OnClickListener {
    //private static final String TAG = HospitalFinderActivity.class.getCanonicalName();
	public static double zoomX;
	public static double zoomY;
	
	double maxLattitude = -180., maxLongitude = -180., minLattitude = 180., minLongitude = 180.;
	public static float scale=1.0f;
	
	public static ArrayList<TermDTO> hospList = new ArrayList<TermDTO>();
	public static ArrayList<TermDTO> favoriteList = new ArrayList<TermDTO>();
	
	private Button nearby;
	private Button rating;
	private Button mapbtn;
	
	private LinearLayout listViewLL;
	
	private ExpandableListView hospListview;
	private HospitalAdapter hospAdapter;
	private MapView mapView;
	private ExpandableListView hospRatingListview;
	private HospitalRatingAdapter hospRatingAdapter;
	
	
	private ImageView reticle;
	private ImageView systemcofig;
	
	private TextView resultstext;
	private ImageView whiteArrowResults;
	
	private TextView bottomTitle;

	List<Overlay> mapOverlays;
	MyItemizedOverlay itemizedOverlay;

	private HospitalFinderDBAdapter sharedDB;
	
	private DecimalFormat decim;
	private int loadCounter = 0;
	
	private String from = "";
	private String searchTxtString = "";
	
	private ArrayList<String> groupList;
	private ArrayList<String> groupRatingList;
	private ArrayList<ArrayList<TermDTO>> completeList = new ArrayList<ArrayList<TermDTO>>();
	private ArrayList<ArrayList<TermDTO>> ratingList = new ArrayList<ArrayList<TermDTO>>();
	
	private int colorr;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        colorr = Color.rgb(245, 245, 245);
        from = HospitalApplication.LOCATION;
        searchTxtString = HospitalApplication.CURRENTLOCATION;
        
        Bundle bn = getIntent().getExtras();
        if(bn!=null)
        {
        	if(bn.containsKey(HospitalApplication.FROM))
        		from = bn.getString(HospitalApplication.FROM);
        	if(bn.containsKey(HospitalApplication.SEARCHTEXT))
        		searchTxtString = bn.getString(HospitalApplication.SEARCHTEXT);
        }
        
		decim = new DecimalFormat("#######.##");
		
        sharedDB = new HospitalFinderDBAdapter(HospitalFinderActivity.this);
    
        nearby = (Button) findViewById(R.id.nearbybutton);
        rating = (Button) findViewById(R.id.ratingbutton);
        mapbtn = (Button) findViewById(R.id.mapbutton);
        
        listViewLL = (LinearLayout) findViewById(R.id.listviewll);
    	hospListview = (ExpandableListView) findViewById(R.id.listview);
    	mapView = (MapView) findViewById(R.id.map_location_viewer);
    	hospRatingListview = (ExpandableListView) findViewById(R.id.ratinglistview);
    	
    	reticle = (ImageView) findViewById(R.id.imgreti);  
        systemcofig = (ImageView) findViewById(R.id.imgsystem);
        
        resultstext = (TextView) findViewById(R.id.resultstext);
        whiteArrowResults = (ImageView) findViewById(R.id.whitearrowresults);  
        
        bottomTitle = (TextView) findViewById(R.id.bottomtitle);
        
        resultstext.setOnClickListener(this);
        nearby.setOnClickListener(this);
        rating.setOnClickListener(this);
        mapbtn.setOnClickListener(this);
        
        reticle.setOnClickListener(this);
		systemcofig.setOnClickListener(this);
		whiteArrowResults.setOnClickListener(this);
		
		mapView.setBuiltInZoomControls(true);
		mapOverlays = mapView.getOverlays();
		
		nearby.setSelected(true);
		mapView.setVisibility(View.GONE);
		hospRatingListview.setVisibility(View.GONE);
		hospListview.setVisibility(View.VISIBLE);
		if(HospitalApplication.getCurrentLocation() != null) {
			double lati = HospitalApplication.getCurrentLocation().getLatitude();
			double longi = HospitalApplication.getCurrentLocation().getLongitude();
			
			if (HospitalApplication.getCurrentLocation()  != null) {
				if (lati > maxLattitude)
					maxLattitude = lati;
				if (lati < minLattitude)
					minLattitude = lati;
				if (longi > maxLongitude)
					maxLongitude = longi;
				if (longi < minLongitude)
					minLongitude = longi;
			}
	
	
			double zLat = 0.0, zLng = 0.0;
			if (HospitalApplication.getCurrentLocation()  == null) {
				zoomX = ((maxLattitude * 1e6 - minLattitude * 1e6) * 1.5) / 4;
				zoomY = ((maxLongitude * 1e6 - minLongitude * 1e6) * 1.5) / 4;
			} else {
				if (zLat != 0.0 && zLng != 0.0) {
					zoomX = Math.abs((HospitalApplication.getCurrentLocation().getLatitude() * 1e6 - zLat * 1e6) * 1.5);
					zoomY = Math.abs((HospitalApplication.getCurrentLocation().getLongitude() * 1e6 - zLng * 1e6) * 1.5);
				} else {
					zoomX = Math.abs((HospitalApplication.getCurrentLocation().getLatitude() * 1e6 - HospitalApplication.getCurrentLocation().getLatitude() * 1e6) * 1.5);
					zoomY = Math.abs((HospitalApplication.getCurrentLocation().getLongitude() * 1e6 - HospitalApplication.getCurrentLocation().getLongitude() * 1e6) * 1.5);
				}
			}
		}
		
		String[] rest = getResources().getStringArray(R.array.groups);
		groupList = new ArrayList<String>();
		for(int i=0;i<rest.length;i++) {
			groupList.add(rest[i]);
		}
		
		groupRatingList = new ArrayList<String>();
		groupRatingList.add(getString(R.string.favoriteshospitals));
		groupRatingList.add(getString(R.string.byrating));
    }
	
	private void loadFavData() {
		sharedDB.open();
		favoriteList = sharedDB.getFavoritesList(HospitalApplication.getCurrentLocation());
		HospitalApplication.currentCompare = HospitalApplication.DISTANCECOMPARE;
	    Collections.sort(favoriteList);
	    sharedDB.close();
	}

   @Override
	protected void onResume() {
		super.onResume();
		if(from.equals(HospitalApplication.LOCATION)) {
			loadCounter = 0;
		}
		Utils.showActivityViewer(HospitalFinderActivity.this,"", true);
		new Thread(new Runnable() {
			@Override
			public void run() {
				if(loadCounter == 0) {
					loadFavData();
					loadData();
					loadCounter++;
					handler.sendEmptyMessage(0);
				}  else {
					loadFavData();
					handler.sendEmptyMessage(1);
				}
				
			}
		}).start();
	}
   
 	private void loadData() {
		mapView.getOverlays().clear();
		sharedDB.open();
		if(from.equals(HospitalApplication.LOCATION) && searchTxtString.equals(HospitalApplication.CURRENTLOCATION)) {
			hospList = sharedDB.getLocationsForMap(HospitalApplication.getCurrentLocation() , HospitalApplication.prefs.getDistance()*HospitalApplication.MILESTOM);
		} else {
			hospList = sharedDB.getLocationsFromSearchString(HospitalApplication.getCurrentLocation() ,HospitalApplication.prefs.getDistance()*HospitalApplication.MILESTOM, searchTxtString);
		}
		HospitalApplication.currentCompare = HospitalApplication.DISTANCECOMPARE;
	    Collections.sort(hospList);
	    
	    completeList.add(favoriteList);
		for (int i = 1; i < groupList.size(); i++) {
			ArrayList<TermDTO> temp = new ArrayList<TermDTO>();
			for (int j = 0; j < hospList.size(); j++) {
				if (i==0 && hospList.get(j).isFavorites()) {
					temp.add(hospList.get(j));
				} else if(i == 1 && hospList.get(j).getDistance() <= 1*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 2 && hospList.get(j).getDistance() <= 3*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 1*HospitalApplication.MILESTOM)  {
					temp.add(hospList.get(j));
				} else if(i == 3 && hospList.get(j).getDistance() <= 5*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 3*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 4 && hospList.get(j).getDistance() <= 10*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 5*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 5 && hospList.get(j).getDistance() <= 15*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 10*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 6 && hospList.get(j).getDistance() <= 20*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 15*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 7 && hospList.get(j).getDistance() <= 40*HospitalApplication.MILESTOM  && hospList.get(j).getDistance() > 20*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 8 && hospList.get(j).getDistance() <= 60*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 40*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 9 && hospList.get(j).getDistance() <= 80*HospitalApplication.MILESTOM  && hospList.get(j).getDistance() > 60*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 10 && hospList.get(j).getDistance() <= 100*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 80*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				} else if(i == 11 && hospList.get(j).getDistance() <= 200*HospitalApplication.MILESTOM && hospList.get(j).getDistance() > 100*HospitalApplication.MILESTOM) {
					temp.add(hospList.get(j));
				}
			}
			completeList.add(temp);
		}
		
		if(completeList.get(0).size() == 0) {
			completeList.get(0).add(null);
		}
		
		HospitalApplication.currentCompare = HospitalApplication.RATINGCOMPARE;
	    Collections.sort(hospList, Collections.reverseOrder());
	    
	    ratingList.add(favoriteList);
		ratingList.add(hospList);
		if(ratingList.get(0).size() == 0) {
			ratingList.get(0).add(null);
		}
		
		HospitalApplication.currentCompare = HospitalApplication.DISTANCECOMPARE;
	    Collections.sort(hospList);
	    
		double zLat=0.0, zLng=0.0;
	    double lat=0.0, lng=0.0;  
	    for(int i=0;i<hospList.size();i++)
		{
	    	TermDTO r = hospList.get(i);
			lat = r.getLatitude();
			lng = r.getLongitude();
			if(hospList.get(i).getDistance() < 16093)
			{
				zLat = lat;
				zLng = lng;
				if (lat > maxLattitude)
					maxLattitude = lat;
				if (lat < minLattitude)
					minLattitude = lat;
				if (lng > maxLongitude)
					maxLongitude = lng;
				if (lng < minLongitude)
					minLongitude = lng;
			}
			String xa = r.getHopital_name() + "--OVXOV--" + decim.format(r.getDistance()/HospitalApplication.MILESTOM) + " mi - "+ r.getAddress();
			itemizedOverlay = new MyItemizedOverlay(getResources().getDrawable(R.drawable.pin), mapView);
			GeoPoint point = new GeoPoint((int)(r.getLatitude()*1E6),(int)(r.getLongitude()*1E6));
			OverlayItem overlayItem = new OverlayItem(point,  xa, r.getId()+"");
			itemizedOverlay.addOverlay(overlayItem);
			mapOverlays.add(itemizedOverlay);
		}
	    if(HospitalApplication.getCurrentLocation()  != null)
	    {
	     	itemizedOverlay = new MyItemizedOverlay(getResources().getDrawable(R.drawable.userlocation), mapView);
			GeoPoint point = new GeoPoint((int)(HospitalApplication.getCurrentLocation().getLatitude()*1E6),(int)(HospitalApplication.getCurrentLocation().getLongitude()*1E6));
			OverlayItem overlayItem = new OverlayItem(point, "",null);
			itemizedOverlay.addOverlay(overlayItem);
			mapOverlays.add(itemizedOverlay);
	    }
	   
		if(HospitalApplication.getCurrentLocation()  == null)
		{
			zoomX =((maxLattitude * 1e6 - minLattitude* 1e6) * 1.5)/4;
			zoomY =((maxLongitude* 1e6 - minLongitude* 1e6) * 1.5)/4;
		}
		else
		{
			if(zLat!=0.0 && zLng != 0.0)
			{
				zoomX =Math.abs((HospitalApplication.getCurrentLocation().getLatitude()* 1e6 - zLat* 1e6) * 1.5);
				zoomY =Math.abs((HospitalApplication.getCurrentLocation().getLongitude()* 1e6 - zLng* 1e6) * 1.5);
			}
			else
			{
				zoomX =Math.abs((HospitalApplication.getCurrentLocation().getLatitude()* 1e6 - lat* 1e6) * 1.5);
				zoomY =Math.abs((HospitalApplication.getCurrentLocation().getLongitude()* 1e6 - lng* 1e6) * 1.5);
			}
		}
		sharedDB.close();
	}
    
    private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if(msg.what == 0) {
				setCenterZoom();
				if(completeList.size() > 0) {
					hospAdapter = new HospitalAdapter();
					hospListview.setAdapter(hospAdapter);
				}
				if(from.equals(HospitalApplication.LOCATION) && !searchTxtString.equals(HospitalApplication.CURRENTLOCATION)) {
					resultstext.setText("Showing hospitals for search string '" + searchTxtString + "'");
				} else {
					resultstext.setText("Showing hospitals within " + HospitalApplication.prefs.getDistance() + " miles of " + (HospitalApplication.prefs.getZipCode() == 0?HospitalApplication.prefs.getCity():HospitalApplication.prefs.getZipCode()));
					//resultstext.setText("Showing hospitals within " + HospitalApplication.prefs.getDistance() + " miles of " + zipCode);
				}
				
				for(int i=0;i<hospAdapter.getGroupCount();i++) {
					hospListview.expandGroup(i);
				}
				
				bottomTitle.setText(HospitalApplication.prefs.getCity());
				if(ratingList.size() > 0) {
					hospRatingAdapter = new HospitalRatingAdapter();
					hospRatingListview.setAdapter(hospRatingAdapter);
				}
				
				for(int i=0;i<hospRatingAdapter.getGroupCount();i++) {
					hospRatingListview.expandGroup(i);
				}
				
				Utils.hideActivityViewer();
			}
			else if(msg.what == 1) {
				if(favoriteList.size() > 0) {
					completeList.get(0).clear();
					completeList.get(0).addAll(favoriteList);
				} else {
					completeList.get(0).clear();
					completeList.get(0).add(null);
				}
				hospAdapter.notifyDataSetChanged();
				hospListview.setSelection(0);
				hospRatingListview.setSelection(0);
				Utils.hideActivityViewer();
			}
		}
	};
	
	

	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}


	@Override
	public void onClick(View v) {
		Intent intent;
		if (v.getId() == R.id.imgreti) {
			from = "";
			intent = new Intent(HospitalFinderActivity.this, LocationActivity.class);
			startActivity(intent);
			finish();
		} else if (v.getId() == R.id.imgsystem) {
			from = "";
			intent = new Intent(HospitalFinderActivity.this, SettingActivity.class);
		    startActivity(intent);
		} else if(v.getId() == R.id.nearbybutton) {
			HospitalApplication.currentCompare = HospitalApplication.DISTANCECOMPARE;
			Collections.sort(hospList);
			listViewLL.setVisibility(View.VISIBLE);
			hospListview.setVisibility(View.VISIBLE);
			hospRatingListview.setVisibility(View.GONE);
			mapView.setVisibility(View.GONE);
			nearby.setSelected(false);
			rating.setSelected(false);
			mapbtn.setSelected(false);
			nearby.setSelected(true);
		} else if(v.getId() == R.id.ratingbutton) {
			HospitalApplication.currentCompare = HospitalApplication.RATINGCOMPARE;
			Collections.sort(hospList, Collections.reverseOrder());
			hospRatingAdapter.notifyDataSetChanged();
			listViewLL.setVisibility(View.VISIBLE);
			hospListview.setVisibility(View.GONE);
			mapView.setVisibility(View.GONE);
			hospRatingListview.setVisibility(View.VISIBLE);
			nearby.setSelected(false);
			rating.setSelected(false);
			mapbtn.setSelected(false);
			rating.setSelected(true);
		} else if(v.getId() == R.id.mapbutton) {
			setCenterZoom();
			hospListview.setVisibility(View.GONE);
			hospRatingListview.setVisibility(View.GONE);
			listViewLL.setVisibility(View.GONE);
			mapView.setVisibility(View.VISIBLE);
			nearby.setSelected(false);
			rating.setSelected(false);
			mapbtn.setSelected(false);
			mapbtn.setSelected(true);
		} else if(v.getId() == R.id.resultstext) {
			from="";
			Intent inte = new Intent(HospitalFinderActivity.this, LocationSettingActivity.class);
			startActivity(inte);
			finish();
		} else if(v.getId() == R.id.whitearrowresults) {
			from="";
			Intent inten = new Intent(HospitalFinderActivity.this, LocationSettingActivity.class);
			startActivity(inten);
			finish();
		}
			
	}
	
	private void setCenterZoom()
	{
		mapView.getController().zoomToSpan((int)(zoomX), (int)(zoomY));
		if(HospitalApplication.getCurrentLocation()!=null) {
			mapView.getController().animateTo(new GeoPoint((int)(HospitalApplication.getCurrentLocation().getLatitude() * 1e6), (int)(HospitalApplication.getCurrentLocation().getLongitude() * 1e6)));
		}
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
	
	public static class ViewHolder{
		TextView name;
		TextView title;
		ProgressBar definitely;
		ProgressBar probablynot;
		TextView miles;
		TextView percentDefinitely;
		TextView percentNot;
		ImageView arrow;
		LinearLayout rl;
    }
	
	public class HospitalAdapter extends BaseExpandableListAdapter {

		public Object getChild(int groupPosition, int childPosition) {
			return completeList.get(groupPosition).get(childPosition);
		}

		public long getChildId(int groupPosition, int childPosition) {
			return childPosition;
		}

		public int getChildrenCount(int groupPosition) {
			return completeList.get(groupPosition).size();
		}

		public View getChildView(int groupPosition, int childPosition,
				boolean isLastChild, View convertView, ViewGroup parent) {
			LayoutInflater inflater = HospitalFinderActivity.this.getLayoutInflater();
			View vi=convertView;
	        ViewHolder holder;
	        if(groupPosition == 0 && completeList.get(groupPosition).size() == 1 && completeList.get(groupPosition).get(0) == null) {
	        	vi = inflater.inflate(R.layout.favoritesemptyview, null);
				holder=new ViewHolder();
				vi.setTag(holder);
	        } else {
	        	vi = inflater.inflate(R.layout.listitemhosp, null);
				holder=new ViewHolder();
				vi.setTag(holder);
					
				if(completeList.get(groupPosition).get(childPosition) != null) {
					final TermDTO xx = completeList.get(groupPosition).get(childPosition);
					
					holder.title=(TextView)vi.findViewById(R.id.hopitalname);
					holder.definitely=(ProgressBar)vi.findViewById(R.id.progressBarDefinitely);
					holder.probablynot=(ProgressBar)vi.findViewById(R.id.progressBarNot);
					holder.percentDefinitely=(TextView)vi.findViewById(R.id.pers_definitely);
					holder.percentNot=(TextView)vi.findViewById(R.id.pers_Not);
					holder.miles=(TextView)vi.findViewById(R.id.mi);
					holder.arrow=(ImageView)vi.findViewById(R.id.arrowimg);
					holder.rl=(LinearLayout)vi.findViewById(R.id.llmain);
					
					if(childPosition%2 == 0)
						holder.rl.setBackgroundColor(colorr);
					else
				    	holder.rl.setBackgroundColor(Color.WHITE);
					
					holder.title.setText(xx.getHopital_name());
					holder.definitely.setProgress(xx.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_());
					holder.probablynot.setProgress(xx.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_());
					holder.percentDefinitely.setText(xx.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_() + "%");
					holder.percentNot.setText(xx.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_() + "%");
					holder.miles.setText(decim.format(xx.getDistance()/HospitalApplication.MILESTOM)  + " mi");
					holder.rl.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							from = "";
							Intent intent = new Intent(HospitalFinderActivity.this, HospitalDetailActivity.class);
							intent.putExtra(HospitalApplication.FROM, HospitalApplication.NEARBY);
							intent.putExtra(HospitalApplication.ID, xx.getId());
							startActivity(intent);
						}
					});
					holder.arrow.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							from = "";
							Intent intent = new Intent(HospitalFinderActivity.this, HospitalDetailActivity.class);
							intent.putExtra(HospitalApplication.FROM, HospitalApplication.NEARBY);
							intent.putExtra(HospitalApplication.ID, xx.getId());
							startActivity(intent);
						}
					});
				}
	        }

			return vi;
		}

		public Object getGroup(int groupPosition) {
			return groupList.get(groupPosition);
		}

		public int getGroupCount() {
			return groupList.size();
		}

		public long getGroupId(int groupPosition) {
			return groupPosition;
		}

		public View getGroupView(int groupPosition, boolean isExpanded,
				View convertView, ViewGroup parent) {
			LayoutInflater inflater = HospitalFinderActivity.this.getLayoutInflater();
			View vi=convertView;
	        ViewHolder holder;
	        vi = inflater.inflate(R.layout.groupview, null);
			holder=new ViewHolder();
			holder.name=(TextView)vi.findViewById(R.id.text);
			vi.setTag(holder);
			holder.name.setText(groupList.get(groupPosition));
	        return vi;
		}

		public boolean isChildSelectable(int groupPosition, int childPosition) {
			return true;
		}

		public boolean hasStableIds() {
			return true;
		}

	}
	
	public class HospitalRatingAdapter extends BaseExpandableListAdapter {

		public Object getChild(int groupPosition, int childPosition) {
			return ratingList.get(groupPosition).get(childPosition);
		}

		public long getChildId(int groupPosition, int childPosition) {
			return childPosition;
		}

		public int getChildrenCount(int groupPosition) {
			return ratingList.get(groupPosition).size();
		}

		public View getChildView(int groupPosition, int childPosition,
				boolean isLastChild, View convertView, ViewGroup parent) {
			LayoutInflater inflater = HospitalFinderActivity.this.getLayoutInflater();
			View vi=convertView;
	        ViewHolder holder;
	        if(groupPosition == 0 && ratingList.get(groupPosition).size() == 1 && ratingList.get(groupPosition).get(0) == null) {
	        	vi = inflater.inflate(R.layout.favoritesemptyview, null);
				holder=new ViewHolder();
				vi.setTag(holder);
	        } else {
	        	vi = inflater.inflate(R.layout.listitemhosp, null);
				holder=new ViewHolder();
				vi.setTag(holder);
					
				if(ratingList.get(groupPosition).get(childPosition) != null) {
					final TermDTO xx = ratingList.get(groupPosition).get(childPosition);
					
					holder.title=(TextView)vi.findViewById(R.id.hopitalname);
					holder.definitely=(ProgressBar)vi.findViewById(R.id.progressBarDefinitely);
					holder.probablynot=(ProgressBar)vi.findViewById(R.id.progressBarNot);
					holder.percentDefinitely=(TextView)vi.findViewById(R.id.pers_definitely);
					holder.percentNot=(TextView)vi.findViewById(R.id.pers_Not);
					holder.miles=(TextView)vi.findViewById(R.id.mi);
					holder.arrow=(ImageView)vi.findViewById(R.id.arrowimg);
					holder.rl=(LinearLayout)vi.findViewById(R.id.llmain);
					
					if(childPosition%2 == 0)
						holder.rl.setBackgroundColor(colorr);
					else
				    	holder.rl.setBackgroundColor(Color.WHITE);
					
					holder.title.setText(xx.getHopital_name());
					holder.definitely.setProgress(xx.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_());
					holder.probablynot.setProgress(xx.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_());
					holder.percentDefinitely.setText(xx.getPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_() + "%");
					holder.percentNot.setText(xx.getPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_() + "%");
					holder.miles.setText(decim.format(xx.getDistance()/HospitalApplication.MILESTOM)  + " mi");
					holder.rl.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							from = "";
							Intent intent = new Intent(HospitalFinderActivity.this, HospitalDetailActivity.class);
							intent.putExtra(HospitalApplication.FROM, HospitalApplication.NEARBY);
							intent.putExtra(HospitalApplication.ID, xx.getId());
							startActivity(intent);
						}
					});
					holder.arrow.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							from = "";
							Intent intent = new Intent(HospitalFinderActivity.this, HospitalDetailActivity.class);
							intent.putExtra(HospitalApplication.FROM, HospitalApplication.NEARBY);
							intent.putExtra(HospitalApplication.ID, xx.getId());
							startActivity(intent);
						}
					});
				}
	        }

			return vi;
		}

		public Object getGroup(int groupPosition) {
			return groupRatingList.get(groupPosition);
		}

		public int getGroupCount() {
			return groupRatingList.size();
		}

		public long getGroupId(int groupPosition) {
			return groupPosition;
		}

		public View getGroupView(int groupPosition, boolean isExpanded,
				View convertView, ViewGroup parent) {
			LayoutInflater inflater = HospitalFinderActivity.this.getLayoutInflater();
			View vi=convertView;
	        ViewHolder holder;
	        vi = inflater.inflate(R.layout.groupview, null);
			holder=new ViewHolder();
			holder.name=(TextView)vi.findViewById(R.id.text);
			vi.setTag(holder);
			holder.name.setText(groupRatingList.get(groupPosition));
	        return vi;
		}

		public boolean isChildSelectable(int groupPosition, int childPosition) {
			return true;
		}

		public boolean hasStableIds() {
			return true;
		}

	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
	}
}