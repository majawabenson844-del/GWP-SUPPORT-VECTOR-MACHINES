data =read.csv("C:/Users/ACCENTURE/OneDrive/Desktop/Music/LID Analysis/augmented_data.csv")
head(data)
# Load libraries
library(Boruta)
library(dplyr)
library(e1071)
library(caret)
library(ggplot2)
library(MASS)
table(dataDecision)
library(cluster)

# Convert target variable to factor
data$Decision <- as.factor(data$Decision)

# Select categorical variables
categorical_vars <- data[, c("Soil.Texture",
                             "Soil.Colour",
                             "Geological.Features",
                             "Elevation",
                             "Natural.vegitation..tree..vigour",
                             "Natural.vegitation..tree..height",
                             "Drainage.Density")]

# Apply one-hot encoding
onehot_matrix <- model.matrix(~ . - 1, data = categorical_vars)

# Inspect the encoded matrix
str(onehot_matrix)

# Combine with target variable
encoded_data <- data.frame(onehot_matrix, Decision = data$Decision)

# Run Boruta
set.seed(123)  # For reproducibility
boruta_result <- Boruta(Decision ~ ., data = data, doTrace = 2)
win.graph()
# Plot Boruta results
# # Set plot margins to provide more space for feature names
par(mar = c(10, 4, 2, 2)) 
plot(boruta_result, las = 2, main = "Boruta Feature Selection", xlab = "", cex.axis = 0.8)

# Add legend
legend("topleft", 
       legend = c("Confirmed", "Tentative", "Rejected"),
       fill = c("forestgreen", "yellow", "red"),
       bty = "n",  # No box around the legend
       title = "Feature Decision")



# Get the final confirmed features
confirmed_features <- getSelectedAttributes(boruta_result, withTentative = FALSE)


# Print confirmed and rejected features
cat("Confirmed Features:\n")
print(confirmed_features)


# Random Forest feature importance
library(randomForest)
rf_model <- randomForest(Decision ~ ., data = train_data, importance = TRUE)
importance(rf_model)




# Data splitting (60-40)
set.seed(123)  # For reproducibility
train_indices <- sample(1:nrow(data), 0.6 * nrow(data))
train_data <- data[train_indices, ]
test_data <- data[-train_indices, ]

# Train SVM model
svm_model <- svm(Decision ~ ., data = train_data, kernel = "linear")

svm_model <- svm(Decision ~ ., data = train_data, 
                 kernel = "linear", 
                 class.weights = c("High Potential" = 2, "Low Potential" = 1))

# Predictions
predictions <- predict(svm_model, test_data)

# Confusion Matrix
confusion_matrix <- confusionMatrix(predictions, test_data$Decision)
print(confusion_matrix)

# Plotting confusion matrix
conf_matrix_df <- as.data.frame(confusion_matrix$table)
ggplot(data = conf_matrix_df, aes(x = Reference, y = Prediction)) +
  geom_tile(aes(fill = Freq), color = "blue") +
  scale_fill_gradient(low = "blue", high = "white") +
  geom_text(aes(label = Freq), vjust = 1) +
  labs(title = "Confusion Matrix", x = "Actual", y = "Predicted")

# Convert categorical variables into a one-hot encoded matrix
train_data_onehot <- model.matrix(~ . - 1, data = train_data)

# Check the structure of the new one-hot encoded data
str(train_data_onehot)
# MDS for visualization
mds_data <- dist(as.matrix(train_data[-1]))  # Exclude target variable
mds_fit <- cmdscale(mds_data)


# Calculate Gower's distance
mds_data <- daisy(train_data_onehot, metric = "gower")

# Perform MDS
mds_fit <- cmdscale(mds_data)

# Create a data frame for plotting
mds_df <- data.frame(MDS1 = mds_fit[, 1], MDS2 = mds_fit[, 2], Class = train_data$confometory)

# Fit SVM model
svm_model <- svm(Class ~ MDS1 + MDS2, data = mds_df, probability = TRUE)

# Create a grid for predictions
grid <- expand.grid(MDS1 = seq(min(mds_df$MDS1), max(mds_df$MDS1), length.out = 100),
                    MDS2 = seq(min(mds_df$MDS2), max(mds_df$MDS2), length.out = 100))

# Predict class labels on the grid
grid$Class <- predict(svm_model, newdata = grid)

# Assign colors based on class
grid$Color <- ifelse(grid$Class == "High Potential", "lightblue", 
                     ifelse(grid$Class == "Low Potential", "lightgreen", "red"))

# Create a decision boundary indicator
grid$DecisionBoundary <- ifelse(grid$Class == "High Potential" | grid$Class == "Low Potential", NA, "red")

# Plot MDS with shaded areas and decision boundary
ggplot() +
  geom_raster(data = grid, aes(x = MDS1, y = MDS2, fill = Color), alpha = 0.5) +
  geom_point(data = mds_df, aes(x = MDS1, y = MDS2, color = Class), size = 3) +
  geom_tile(data = grid, aes(x = MDS1, y = MDS2, fill = DecisionBoundary), alpha = 0.2) +
  scale_fill_identity() +  # Use the fill colors as defined
  labs(title = "Groundwater Potential Mapping Class Separaton") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

# Check for NA values in the training data
sum(is.na(train_data))





