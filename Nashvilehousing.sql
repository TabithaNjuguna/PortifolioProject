
Cleaning Data in SQL Queries

Select *
From PortifolioProject..nashivilehousing



-- Standardize Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortifolioProject..nashivilehousing


Update PortifolioProject..nashivilehousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE PortifolioProject..nashivilehousing
Add SaleDateConverted Date;

Update PortifolioProject..nashivilehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From PortifolioProject..nashivilehousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortifolioProject..nashivilehousing a
JOIN PortifolioProject..nashivilehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortifolioProject..nashivilehousing a
JOIN PortifolioProject..nashivilehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortifolioProject..nashivilehousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortifolioProject..nashivilehousing

ALTER TABLE PortifolioProject..nashivilehousing
Add PropertySplitAddress Nvarchar(255)

Update PortifolioProject..nashivilehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE PortifolioProject..nashivilehousing
Add PropertySplitCity Nvarchar(255);

Update PortifolioProject..nashivilehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select*
From PortifolioProject..nashivilehousing

Select OwnerAddress
From PortifolioProject..nashivilehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortifolioProject..nashivilehousing

ALTER TABLE PortifolioProject..nashivilehousing
Add OwnerSplitAddress Nvarchar(255);

Update PortifolioProject..nashivilehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortifolioProject..nashivilehousing
Add OwnerSplitCity Nvarchar(255);

Update PortifolioProject..nashivilehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortifolioProject..nashivilehousing
Add OwnerSplitState Nvarchar(255);

Update PortifolioProject..nashivilehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select*
From PortifolioProject..nashivilehousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortifolioProject..nashivilehousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortifolioProject..nashivilehousing

Update PortifolioProject..nashivilehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   -- Remove Duplicates
WITH RowNumCTE AS(
	   Select*,
	     ROW_NUMBER() OVER(
		 PARTITION BY PropertyAddress,
				      SalePrice,
				      SaleDate,
				      LegalReference
                      ORDER BY
					  uniqueID
					  ) row_num

From PortifolioProject..nashivilehousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

Select*
From PortifolioProject..nashivilehousing


-- Delete Unused Columns

Select*
From PortifolioProject..nashivilehousing

ALTER TABLE PortifolioProject..nashivilehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


