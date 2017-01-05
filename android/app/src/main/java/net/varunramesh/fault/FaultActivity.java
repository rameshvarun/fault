package net.varunramesh.fault;
import android.os.Bundle;
import android.util.Log;

import org.love2d.android.GameActivity;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.Player;
import com.google.example.games.basegameutils.BaseGameUtils;

public class FaultActivity extends GameActivity implements GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener {
    private static String TAG = "FaultActivity";

    // Client used to interact with Google APIs
    private GoogleApiClient mGoogleApiClient;

    // Are we currently resolving a connection failure?
    private boolean mResolvingConnectionFailure = false;

    // Has the user clicked the sign-in button?
    private boolean mSignInClicked = false;

    // Automatically start the sign-in flow when the Activity starts
    private boolean mAutoStartSignInFlow = true;

    private static final int RC_UNUSED = 5001;
    private static final int RC_SIGN_IN = 9001;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Create the Google API Client with access to Games
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(Games.API).addScope(Games.SCOPE_GAMES)
                .build();
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "onStart(): connecting");
        mGoogleApiClient.connect();
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "onStop(): disconnecting");
        if (mGoogleApiClient.isConnected()) {
            mGoogleApiClient.disconnect();
        }
    }

    @Override
    public void onConnected(Bundle bundle) {

    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.d(TAG, "onConnectionSuspended(): attempting to reconnect");
        mGoogleApiClient.connect();
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Log.d(TAG, "onConnectionFailed(): attempting to resolve");
        if (mResolvingConnectionFailure) {
            Log.d(TAG, "onConnectionFailed(): already resolving");
            return;
        }

        if (mSignInClicked || mAutoStartSignInFlow) {
            mAutoStartSignInFlow = false;
            mSignInClicked = false;
            mResolvingConnectionFailure = true;
            if (!BaseGameUtils.resolveConnectionFailure(this, mGoogleApiClient, connectionResult,
                    RC_SIGN_IN, getString(R.string.signin_other_error))) {
                mResolvingConnectionFailure = false;
            }
        }
    }

    /** Functions that will be exposed to Lua. */
    public void showAchievements() {
        startActivityForResult(Games.Achievements.getAchievementsIntent(mGoogleApiClient), RC_UNUSED);
    }
    public void showLeaderboard(String id){
        startActivityForResult(Games.Leaderboards.getLeaderboardIntent(mGoogleApiClient, id), RC_UNUSED);
    }
    public void showAllLeaderboards(){
        startActivityForResult(Games.Leaderboards.getAllLeaderboardsIntent(mGoogleApiClient), RC_UNUSED);
    }
    public boolean isGooglePlayConnected() {
        return (mGoogleApiClient != null && mGoogleApiClient.isConnected());
    }
    public void googlePlayConnect() {
        mGoogleApiClient.connect();
    }

    public void unlockAchievement(String id){
        if (isGooglePlayConnected()){
            Games.Achievements.unlock(mGoogleApiClient, id);
        }
    }

    public void incrementAchievement(String id, int inc){
        if (isGooglePlayConnected()){
            Games.Achievements.increment(mGoogleApiClient, id, inc);
        }
    }

    public void submitScore(String id, double score){
        if (isGooglePlayConnected()){
            Games.Leaderboards.submitScore(mGoogleApiClient, id, (long)(score));
        }
    }
}
