/***
 * Copyright (c) 2010 readyState Software Ltd
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 */

package com.micro.health.hospital.finder;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;

import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

public class MyItemizedOverlay extends BalloonItemizedOverlay<OverlayItem> {

	private ArrayList<OverlayItem> m_overlays = new ArrayList<OverlayItem>();
	private Context c;

	public MyItemizedOverlay(Drawable defaultMarker, MapView mapView) {
		super(boundCenter(defaultMarker), mapView);
		c = mapView.getContext();
	}

	public void addOverlay(OverlayItem overlay) {
		m_overlays.add(overlay);
		populate();
	}

	@Override
	protected OverlayItem createItem(int i) {
		return m_overlays.get(i);
	}

	@Override
	public int size() {
		return m_overlays.size();
	}

	@Override
	public void draw(Canvas canvas, MapView mapView, boolean shadow)
	{
		if(!shadow)
		{
			super.draw(canvas, mapView, false);
		}
	}


	@Override
	protected boolean onBalloonTap(int index, OverlayItem item) {
		Intent storeIntent = new Intent(c, HospitalDetailActivity.class);
		storeIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
		storeIntent.putExtra(HospitalApplication.FROM, HospitalApplication.MAP);
		storeIntent.putExtra(HospitalApplication.ID, Integer.parseInt(item.getSnippet()));
		c.startActivity(storeIntent);
		return true;
	}

}
