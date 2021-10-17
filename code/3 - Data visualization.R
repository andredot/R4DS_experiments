# install.packages("tidyverse")
library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
# fuel efficiency decrease as increase engine size

# 3.2.4 exercises
# 1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg) #empty page

# 2. How many rows are in mpg? How many columns?
dim(mpg) # 234 rows, 11 columns

# 3. What does the drv variable describe?
?mpg # type of drive train

# 4. Make a scatterplot of hwy vs cyl
ggplot(data = mpg) +
  geom_point(mapping = aes(x= cyl, y=hwy))

# 5. What happens if you make a scatterplot of class vs drv?
# Why is the plot not useful?
ggplot(data = mpg) +
  geom_point(mapping = aes(x= drv, y=class))
# does not provide information on how many cars have those features


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 3.2.4 exercises
# 1. What’s gone wrong with this code?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. Which variables in mpg are categorical? Which variables are continuous?
?mpg # categorical <- manufacturer, model, trans, drv, fl, class
summary(mpg) # continuous <- displ, year, cyl,cty, hwy

# 3. Map a continuous variable to color, size, and shape.
# How do these aesthetics behave differently?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = year)) # scale of colors
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl)) # useless
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty)) # error

# 4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, 
                           y = hwy, 
                           color = class,
                           shape = class)) # combined effect

# 5. What does the stroke aesthetic do?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, 
                           y = hwy, 
                           color = class,
                           stroke = displ))
?geom_point
vignette("ggplot2-specs") # stroke is border width, only for continuous

# 6. What happens if you map an aesthetic to something other than a var name?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, 
                           y = hwy, 
                           color = displ < 5)) # conditional plotting



ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .)

# 3.5.1 Exercises
# 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ cty) # tries to categorize
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ year) #fails to categorize (too many maybe?)

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean?
# How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl) # no points means there is no car with those features
ggplot(data = mpg) + # same plot as the facet but with overplotting
  geom_point(mapping = aes(x = drv, y = cyl)) 

# 3. What plots does the following code make?
# hwy vs displ plot with three faceted rows showing drive categories (4,f,r)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# hwy vs displ plot with faceted columns showing cylinder number
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# 4. Take the first faceted plot in this section
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# What are the advantages to using faceting instead of the colour aesthetic?
# easier to see categories and intra-category variability
# What are the disadvantages?
# more difficult to compare categories
# How might the balance change if you had a larger dataset?
# the bigger the dataset, the messier the color visualization
# the noisier the dataset, the messier the color visualization

# 5. Read facet_wrap
?facet_wrap()
# What does nrow and ncol do? number of rows and column
# What other options control the layout of the individual panels? scales, 
# shrink, drop
# Why doesn’t facet_grid() have nrow and ncol arguments? because they are
# taken from categories of data in the function

# 6. When using facet_grid() you should usually put the variable with more 
# unique levels in the columns. Why? better use of screen space and clarity


ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(mapping = aes(color = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


# 3.6.1 Execises
# 1. What geom would you use to draw a line chart? geom_line() or geom_smooth()

# 2. Run this code in your head and predict what the output will look like
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3. What does show.legend = FALSE do? Remove the legend
# What happens if you remove it? legend will appear, graph is bigger

# 4. What does the se argument to geom_smooth() do? Set a method
# Display confidence interval around smooth

# 5. Will these two graphs look different? Why? No because aes is passed to geom
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6.Recreate the R code necessary to generate the following graphs
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = drv)) + 
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, 
                                 y = hwy, 
                                 color = drv)) + 
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, 
                                 y = hwy)) + 
  geom_point(mapping = aes(color = drv) ) +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE, mapping = aes(linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, 
                                 y = hwy)) + 
  geom_point(color = "white", stroke = 3) +
  geom_point(mapping = aes(color = drv), size = 2)
  

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# 3.7.1 Exercises
# 1. What is the default geom associated with stat_summary()? geom_pointrange() 
# How could you rewrite the previous plot to use that geom function?
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) + 
  geom_pointrange(stat = "summary",
                  fun.min = min,
                  fun.max = max,
                  fun = median)

# 2.What does geom_col() do? How is it different to geom_bar()?
#  heights of the bars represent values in the data, not the count

# 3. -done on index help, they have the same name
# 4. What variables does stat_smooth() compute?
# y (predicted value), ymin and ymax (conf. interval), se (standard error)
# What parameters control its behaviour? method, se, n, span, fullrange, level

# 5. In our proportion bar chart, we need to set group = 1. Why?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop))) 
# otherwise proportion will be calculated group-wise (100% each group)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))
# corrected version
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color))


ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# 3.8.1 Exercises
# 1. What is the problem with this plot? How could you improve it?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() # overplotting
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()

# 2. What parameters to geom_jitter() control the amount of jittering?
# width, height

# 3. Compare and contrast geom_jitter() with geom_count()
# both:  mitigates risk of overplotting
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter() # errors but works with color
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_count() # size not proportional to number (area), no colors if multiclass

# 4. What’s the default position adjustment for geom_boxplot()? "dodge2"
# Create a visualisation of the mpg dataset that demonstrates it.
ggplot(data = mpg, mapping = aes(cty, y = hwy, colour = class)) + 
  geom_boxplot()


ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# 3.9.1 Exercises
# 1. Turn a stacked bar chart into a pie chart using coord_polar()
ggplot(data = diamonds,
       show.legend = FALSE,
       width = 1) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL) +
  geom_bar(mapping = aes(x = 1, fill = cut)) +
  coord_polar(theta = "y")

# 2. What does labs() do?
# set title, subtitle, caption (bottom-right) and tag (top-left)

# 3. What is the difference between coord_quickmap() and coord_map()?
# Map do not preserve straight lines (considerable computation), quickmap does

# 4. What does the plot below tell you about the relationship 
# between city and highway mpg? fuel efficiency is higher in city than highway
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()
# Why is coord_fixed() important? otherwise scales are not related 
# What does geom_abline() do? a line with slope = 1 and intercept = 0 by default