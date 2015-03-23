package com.micro.health.hospital.finder;

import java.util.ArrayList;
import java.util.Collections;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.micro.health.hospital.finder.database.HospitalFinderDBAdapter;

public class LocationActivity extends Activity implements OnClickListener {
	private Button clear;
	private Button cancel;
	
	private AutoCompleteTextView searchTxt;
	private ImageView editCancel;
	private ListView searchListView;
	
	private ArrayList<String> hospitalNames = new ArrayList<String>();
	private SearchAdapter searchAdapter;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.location);
		clear = (Button) findViewById(R.id.clearbtn);
		cancel = (Button) findViewById(R.id.cancelbtn);
		
		searchTxt = (AutoCompleteTextView) findViewById(R.id.searchtext);
		editCancel = (ImageView) findViewById(R.id.searchcancel);
		searchListView = (ListView) findViewById(R.id.searchlist);
		
		clear.setOnClickListener(this);
		cancel.setOnClickListener(this);
		
		HospitalFinderDBAdapter dbAdapter = new HospitalFinderDBAdapter(LocationActivity.this);
		dbAdapter.open();
		hospitalNames = dbAdapter.getAllHospitalNames();
		dbAdapter.close();
		
		Collections.sort(hospitalNames);
		
		searchTxt.addTextChangedListener(searchTextWatcher);
		searchTxt.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_dropdown_item_1line, hospitalNames));
	        
		searchTxt.setOnEditorActionListener(new TextView.OnEditorActionListener() {
	    	    @Override
	    	    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
	    	        if (actionId == EditorInfo.IME_ACTION_SEARCH) {
	    	        	//closeSearch();
	    	            performSearch();
	    	            return true;
	    	        }
	    	        return false;
	    	    }
	    	});
		
		editCancel.setOnClickListener(this);
		searchAdapter = new SearchAdapter(LocationActivity.this);
		searchListView.setAdapter(searchAdapter);
	}
	
   private void performSearch()
   {
	   	String searchTxtString = searchTxt.getText().toString();
	   	HospitalApplication.getHistorySearchList().add(searchTxtString);
	   	searchAdapter.notifyDataSetChanged();
	   	Intent intent = new Intent(LocationActivity.this, HospitalFinderActivity.class);
		intent.putExtra(HospitalApplication.FROM, HospitalApplication.LOCATION);
		intent.putExtra(HospitalApplication.SEARCHTEXT, searchTxtString);
		startActivity(intent);
   }
	    
	
	private void closeSearch()
	{
		editCancel.setVisibility(View.GONE);
		InputMethodManager mgr = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		mgr.hideSoftInputFromWindow(searchTxt.getWindowToken(), 0);
	}
	
	private TextWatcher searchTextWatcher = new TextWatcher() {
		
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if(s.length() > 0) {
				editCancel.setVisibility(View.VISIBLE);
			} else {
				closeSearch();
			}
		}
		
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			
		}
		
		@Override
		public void afterTextChanged(Editable s) {
			
		}
	};

	public void onClick(View v) {
		if (v.getId() == R.id.clearbtn) {
			HospitalApplication.setHistorySearchList(new ArrayList<String>());
			HospitalApplication.getHistorySearchList().add(HospitalApplication.CURRENTLOCATION);
			searchAdapter.notifyDataSetChanged();
		} else if (v.getId() == R.id.cancelbtn) {
			onBackPressed();
		} else if (v.getId() == R.id.searchcancel) {
			searchTxt.setText("");
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
		Intent intent = new Intent(LocationActivity.this, HospitalFinderActivity.class);
		startActivity(intent);
		finish();
	}
	
	public static class ViewHolder{
		TextView title;
		LinearLayout rl;
    }
	
	private class SearchAdapter extends ArrayAdapter<String> {
		public SearchAdapter(Context context) {
			super(context, R.layout.searchlist);
		}

		public int getCount() {
			return HospitalApplication.getHistorySearchList().size();
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View vi=convertView;
	        ViewHolder holder;
	        LayoutInflater inflater = LocationActivity.this.getLayoutInflater();
        	vi = inflater.inflate(R.layout.searchlist, null);
			holder=new ViewHolder();
			vi.setTag(holder);
			
			if(HospitalApplication.getHistorySearchList().get(position) != null) {
				final String xx = HospitalApplication.getHistorySearchList().get(position);
				
				holder.title=(TextView)vi.findViewById(R.id.searchname);
				holder.rl=(LinearLayout)vi.findViewById(R.id.llmain);
				
				holder.title.setText(xx);
				
				holder.title.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(LocationActivity.this, HospitalFinderActivity.class);
						intent.putExtra(HospitalApplication.FROM, HospitalApplication.LOCATION);
						intent.putExtra(HospitalApplication.SEARCHTEXT, xx);
						startActivity(intent);
					}
				});
			}
	        return vi;
		}
		
		

	}
}
