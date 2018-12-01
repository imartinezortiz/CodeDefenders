package org.codedefenders.execution;

import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.codedefenders.database.DatabaseAccess;
import org.codedefenders.database.KillmapDAO;
import org.codedefenders.game.multiplayer.MultiplayerGame;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class setups the thread pool to process games killmaps asynchronously.
 * It reads from the DB KillMapJobs the id of the games waiting for their
 * killmap to be computed, and processes them one at the time. Results are then
 * stored to killmap, and the job is removed from the database
 * 
 * TODO We should need to decouple the actual processor from the context
 * listener for better testing.
 * 
 * @author gambi
 *
 */
@WebListener
public class KillMapProcessor implements ServletContextListener {

    private static Logger logger = LoggerFactory.getLogger(KillMapProcessor.class);

    private ScheduledExecutorService executor;

    // Do we need those to be configurable ? Not until further notice !
    private static final int INITIAL_DELAY_VALUE = 20;
    private static final int EXECUTION_DELAY_VALUE = 10;
    private static final TimeUnit EXECUTION_DELAY_UNIT = TimeUnit.SECONDS;

    // Ref name
    public static final String NAME = "KILLMAP_PROCESSOR";

    // This is reset everytime we re-deploy the app.
    // We make it easy: instead of stopping and restarting the executor, we
    // simply skip the job if the processor is disabled
    private static boolean isEnabled = true;

    private class KillMapJob implements Runnable {

        @Override
        public void run() {
            if (!isEnabled) {
                return;
            }
            // Retrieve a kill map job from the DB and execute it
            boolean recalculate = true;
            // Retrieve all of them to have a partial count, but execute only
            // the first
            List<Integer> gamesToProcess = KillmapDAO.getPendingJobs();
            if (gamesToProcess.isEmpty()) {
                logger.debug("No killmap computation to process");
                return;
            } else {
                try {
                    MultiplayerGame game = DatabaseAccess.getMultiplayerGame(gamesToProcess.get(0));
                    logger.info("Computing killmap for game " + game.getId());
                    KillMap.forGame(game, recalculate);
                    logger.info("Killmap for game " + game.getId() + ". Remove job from DB");
                    // At this point we can remove the job from the DB
                    KillmapDAO.removeJob(game.getId());
                } catch (InterruptedException | ExecutionException e) {
                    // TODO If the job fails and we leave it, we risk to create
                    // a loop !
                    logger.warn("Killmap computation failed!", e);
                } catch (Throwable e) {
                    // TODO: handle exception ?
                    logger.warn("Killmap computation failed!", e);
                }
            }
        }
    }

    public KillMapProcessor() {
    }

    public boolean isEnabled() {
        return isEnabled;
    }

    public void setEnabled(boolean isEnabled) {
        KillMapProcessor.isEnabled = isEnabled;
    }

    /**
     * Return the ID of the games for which there's a pending killmap
     * computation
     * 
     * @return
     */
    public List<Integer> getPendingJobs() {
        return KillmapDAO.getPendingJobs();
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        /*
         * Note: the size of the thread pool for the moment is fixed to 1. If
         * this thread dies for whatever reason the killmap computation will die
         * as well
         */
        executor = Executors.newScheduledThreadPool(1);
        logger.info("KillMapProcessor Started ");
        executor.scheduleWithFixedDelay(new KillMapJob(), INITIAL_DELAY_VALUE, EXECUTION_DELAY_VALUE,
                EXECUTION_DELAY_UNIT);

        ServletContext context = sce.getServletContext();
        // This smells fishy, probably we need to pass the actual Processor once
        // we factor it out from the listener
        context.setAttribute(NAME, this);
        logger.info("KillMapProcessor registered in context as {} ", NAME);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            sce.getServletContext().removeAttribute(NAME);

            logger.info("KillMapProcessor Shutting down");
            // Cancel pending jobs
            executor.shutdownNow();
            executor.awaitTermination(20, TimeUnit.SECONDS);
            logger.info("KillMapProcessor Shut down");
        } catch (InterruptedException e) {
            logger.warn("KillMapProcessor Shutdown interrupted", e);
        }
    }

}
